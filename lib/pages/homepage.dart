import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:possystem/components/uihelper.dart';
import 'package:possystem/models/order.dart';
import 'package:possystem/pages/inventorypage.dart';
import 'package:provider/provider.dart';
import '../components/category_selector.dart';
import '../components/filter_and_search_row.dart';
import '../components/menu_items_grid.dart';
import '../components/order_summary_panel.dart';
import '../components/tooglebtn.dart';
import '../components/variant_popup.dart';
import '../models/menu_category.dart';
import '../models/menu_item.dart';
import '../models/table.dart';
import '../providers/inventory_provider.dart';
import '../providers/order_provider.dart';
import '../services/firestore_service.dart';
import '../utils/match.dart';
import 'loginpage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<MenuCategory> categories = [];
  late List<TableData> tables = [];
  MenuCategory? selectedCategory;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataFromFirestore();
  }

  Future<void> _loadDataFromFirestore() async {
    try {
      print("🔄 Loading data from Firestore...");

      // Fetch tables from Firestore
      final fetchedTables = await FirestoreService.fetchTables();

      // Fetch menu categories from Firestore
      final fetchedCategories = await FirestoreService.fetchMenuCategories();

      if (mounted) {
        setState(() {
          tables = fetchedTables;
          categories = fetchedCategories;
          selectedCategory = categories.isNotEmpty ? categories.first : null;
          isLoading = false;
        });
      }
      print("✅ All data loaded successfully!");
    } catch (e) {
      print("❌ Error loading data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while fetching data
    if (isLoading) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(title: const Text("PopNFry")),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Show error if no data
    if (categories.isEmpty || tables.isEmpty) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(title: const Text("PopNFry")),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("⚠️ No data found in Firestore"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadDataFromFirestore,
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    final allItems = selectedCategory?.items ?? [];
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      // Fixed: Removed tiny PreferredSize that was hiding content
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          leading: Image.asset("assets/images/logo.png"),
          title: const Text(""),
          actions: [
            IconButton(
              onPressed: () {
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider(
                        create: (_) => InventoryProvider(),
                        child: const InventoryPage(),
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.view_list_outlined),
              tooltip: "inventory",
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                }
              },
              icon: const Icon(Icons.logout),
              tooltip: "Logout",
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      body: Row(
        children: [
          // 1. Left: Menu + Category Selector
          Expanded(
            flex: 3,
            child: Column(
              children: [
                CategorySelector(
                  categories: categories,
                  selectedCategory: selectedCategory,
                  onCategorySelected: (category) {
                    setState(() => selectedCategory = category);
                  },
                ),
                Consumer<OrderProvider>(
                  builder: (context, orderProvider, child) {
                    var filteredItems = allItems;

                    // Apply veg filter
                    if (orderProvider.showVegOnly) {
                      filteredItems = filteredItems
                          .where((item) => item.isVeg)
                          .toList();
                    }
                    // Apply search filter
                    if (orderProvider.searchQuery.isNotEmpty) {
                      filteredItems = filteredItems
                          .where(
                            (item) => matchesSearch(
                              item.name,
                              orderProvider.searchQuery,
                            ),
                          )
                          .toList();
                    }
                    return Expanded(
                      child: Column(
                        children: [
                          FilterAndSearchRow(
                            showVegOnly: orderProvider.showVegOnly,
                            onVegToggled: (value) {
                              orderProvider.toggleVegFilter(value);
                            },
                            onSearchChanged: (query) {
                              orderProvider.updateSearchQuery(query);
                            },
                            searchQuery: orderProvider.searchQuery,
                          ),
                          Expanded(
                            child: MenuItemsGrid(
                              items: filteredItems,
                              selectedItems: orderProvider.selectedItems,
                              onItemToggled: (item) {
                                if (orderProvider.selectedItems.contains(
                                  item,
                                )) {
                                  orderProvider.removeItem(item, tables);
                                } else {
                                  if (item.haveVariants) {
                                    VariantPopup.showVariantPopup(
                                      context,
                                      item,
                                      orderProvider,
                                    );
                                  } else {
                                    orderProvider.addItem(item);
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // 2. Middle: Tables Grid
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "TABLES",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.2,
                          ),
                      itemCount: tables.length,
                      itemBuilder: (context, index) {
                        final tableData = tables[index];
                        return Consumer<OrderProvider>(
                          builder: (context, orderProvider, child) {
                            final double tableTotal = orderProvider
                                .getTableTotal(tableData.number);
                            return Helper.CustomTableCard(
                              status: tableData.status,
                              onSelect: () {
                                orderProvider.selectTable(
                                  tableData.number,
                                  tables,
                                );
                              },
                              onDeselect: () {
                                orderProvider.deselectTable(
                                  tableData.number,
                                  tables,
                                );
                              },
                              text: "Table ${tableData.number}",
                              tableTotal: tableTotal > 0
                                  ? "₹${tableTotal.toInt()}"
                                  : "",
                              isSelected:
                                  orderProvider.selectedTable ==
                                  tableData.number,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Right: Order Summary Panel
          Expanded(
            flex: 2,
            child: Consumer<OrderProvider>(
              builder: (context, orderProvider, child) {
                return OrderSummaryPanel(
                  // We only pass things that aren't in the Provider
                  orderContext: orderProvider.selectedTable > 0
                      ? "Table ${orderProvider.selectedTable}"
                      : "Counter Order",
                  tables: tables,
                  onPaymentComplete: () {
                    orderProvider.clearOrder(tables);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
