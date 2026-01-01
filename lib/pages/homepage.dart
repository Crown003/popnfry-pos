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
import '../models/menu_category.dart';
import '../models/menu_item.dart';
import '../models/table.dart';
import '../providers/order_provider.dart';
import 'loginpage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<MenuCategory> categories;
  MenuCategory? selectedCategory;
  late List<TableData> tables;

  @override
  void initState() {
    super.initState();
    categories = [
      MenuCategory(
        name: "Pizza",
        icon: Icons.local_pizza,
        items: [
          MenuItem(
            name: "Margherita",
            price: 180,
            imagePlaceholder: "Margherita.png",
            isVeg: true,
          ),
          MenuItem(
            name: "Pepperoni Feast",
            price: 350,
            imagePlaceholder: "Pepperoni_Feast.png",
            isVeg: false,
          ),
          MenuItem(
            name: "Veggie Supreme",
            price: 280,
            imagePlaceholder: "Veggie_Supreme.png",
            isVeg: true,
          ),
        ],
      ),
      MenuCategory(
        name: "Burgers",
        icon: Icons.lunch_dining,
        items: [
          MenuItem(
            name: "Classic Aloo Tikki",
            price: 120,
            imagePlaceholder: "Classic_Aloo_Tikki.png",
            isVeg: true,
          ),
          MenuItem(
            name: "Crispy Chicken Burger",
            price: 220,
            imagePlaceholder: "Crispy_Chicken_Burger.png",
            isVeg: false,
          ),
          MenuItem(
            name: "Double Cheese Smash",
            price: 290,
            imagePlaceholder: "Double_Cheese_Smash.png",
            isVeg: true,
          ),
        ],
      ),
      MenuCategory(
        name: "Sides",
        icon: Icons.fastfood,
        items: [
          MenuItem(
            name: "Peri Peri Fries",
            price: 110,
            imagePlaceholder: "Peri_Peri_Fries.png",
            isVeg: true,
          ),
          MenuItem(
            name: "Chicken Wings (6pcs)",
            price: 240,
            imagePlaceholder: "Chicken_Wings.png",
            isVeg: false,
          ),
          MenuItem(
            name: "Garlic Breadsticks",
            price: 140,
            imagePlaceholder: "Garlic_Breadsticks.png",
            isVeg: true,
          ),
        ],
      ),
      MenuCategory(
        name: "Beverages",
        icon: Icons.local_drink,
        items: [
          MenuItem(
            name: "Cold Coffee",
            price: 150,
            imagePlaceholder: "Cold_Coffee.png",
            isVeg: true,
          ),
          MenuItem(
            name: "Fresh Lime Soda",
            price: 80,
            imagePlaceholder: "Fresh_Lime_Soda.png",
            isVeg: true,
          ),
        ],
      ),
    ];

    tables = [
      TableData(number: 1, status: Status.free),
      TableData(number: 2, status: Status.free),
      TableData(number: 3, status: Status.free),
      TableData(number: 4, status: Status.free),
      TableData(number: 5, status: Status.free),
    ];

    selectedCategory = categories.first;
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: (){
                // await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const InventoryPage()),
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
                      filteredItems = filteredItems.where((item) =>
                          item.name.toLowerCase().contains(
                              orderProvider.searchQuery.toLowerCase())).toList();
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
                                if (orderProvider.selectedItems.contains(item)) {
                                  orderProvider.removeItem(item,tables);
                                } else {
                                  orderProvider.addItem(item);
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
            flex: 5,
            child: Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "TABLES",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
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
                            // Get the total for this specific table
                            final double tableTotal = orderProvider.getTableTotal(tableData.number);

                            return Helper.CustomTableCard(
                              onSelect: () {
                                orderProvider.selectTable(tableData.number, tables);
                              },
                              onDeselect: () {
                                orderProvider.deselectTable(tableData.number, tables);
                              },
                              text: "Table ${tableData.number}",
                              // Add a subtitle or extra text to show the price if occupied
                              tableTotal: tableTotal > 0 ? "₹${tableTotal.toInt()}" : "",
                              isSelected: orderProvider.selectedTable == tableData.number,
                              isOccupied: tableData.status == Status.occupied,
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