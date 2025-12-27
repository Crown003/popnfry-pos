import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:possystem/components/uihelper.dart';
import 'package:possystem/models/order.dart';
import '../components/category_selector.dart';
import '../components/filter_and_search_row.dart';
import '../components/menu_items_grid.dart';
import '../components/order_summary_panel.dart';
import '../components/tooglebtn.dart';
import '../models/menu_category.dart';
import '../models/menu_item.dart';
import '../models/table.dart';
import 'loginpage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // MyHomePage
  late List<MenuItem> _selectedItems = [];
  late List<TableData> tables;
  late Map<int, Order> orders;
  // late List<MenuItem> _tableOrders = [];
  // late List<MenuItem> _counterOrderItems = [];
  late List<MenuCategory> categories;
  MenuCategory? selectedCategory;
  bool showVegOnly = true;
  int _selectedTable = 0;
  @override
  void initState() {
    super.initState();
    // Sample data - you can load this from API/database later
    orders = {};
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
            name: "Farm Fresh",
            price: 220,
            imagePlaceholder: "Margherita1.png",
            isVeg: true,
          ),
          MenuItem(
            name: "Chicken Tikka",
            price: 320,
            imagePlaceholder: "",
            isVeg: false,
          ),
          MenuItem(
            name: "Margherita",
            price: 180,
            imagePlaceholder: "",
            isVeg: true,
          ),
          MenuItem(
            name: "Farm Fresh",
            price: 220,
            imagePlaceholder: "",
            isVeg: true,
          ),
          MenuItem(
            name: "Chicken Tikka",
            price: 320,
            imagePlaceholder: "",
            isVeg: false,
          ),
        ],
      ),
      MenuCategory(
        name: "Burgers",
        icon: Icons.fastfood,
        items: [
          MenuItem(
            name: "Veg Maharaja",
            price: 150,
            imagePlaceholder: "",
            isVeg: true,
          ),
          MenuItem(
            name: "Chicken Maharaja",
            price: 190,
            imagePlaceholder: "",
            isVeg: false,
          ),
        ],
      ),
      MenuCategory(
        name: "Sides",
        icon: Icons.favorite_border,
        items: [
          MenuItem(
            name: "Garlic Bread",
            price: 120,
            imagePlaceholder: "",
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

  List<MenuItem> _getFilteredItems() {
    var items = selectedCategory?.items ?? [];
    if (showVegOnly) {
      items = items.where((item) => item.isVeg).toList();
    }
    return items;
  }

  // logout() async {
  //   try {
  //     FirebaseAuth.instance.signOut();
  //   } catch (err) {
  //     print(err.toString());
  //   } finally {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => LoginPage()),
  //     );
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    final currentItems = _getFilteredItems();
    final ColorScheme colors = Theme.of(context).colorScheme;
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(
          leading: Image.asset("assets/images/logo.png"),
          title: Text("PopNFry"),
          actions: [
            //logout button
            IconButton(onPressed: () {}, icon: Icon(Icons.logout, size: 14)),
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Search Bar + Veg/Non-Veg Toggle
                CategorySelector(
                  categories: categories,
                  selectedCategory: selectedCategory,
                  onCategorySelected: (category) {
                    setState(() => selectedCategory = category);
                  },
                ),
                FilterAndSearchRow(
                  showVegOnly: showVegOnly,
                  onVegToggled: (value) => setState(() => showVegOnly = value),
                ),

                // Items Grid (placeholders)
                Expanded(
                  child: MenuItemsGrid(
                    items: currentItems,
                    selectedItems: _selectedItems,
                    onItemToggled: (item) {
                      setState(() {
                        if (_selectedItems.contains(item)) {
                          _selectedItems.remove(item);
                        } else {
                          _selectedItems.add(item);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // 2. Middle: Tables area
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    "TABLES",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tables Grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                      itemCount: tables.length,
                      itemBuilder: (context, index) {
                        final tableData = tables[index];

                        return Helper.CustomTableCard(
                          onSelect: () {
                            setState(() {
                              // Save current items before switching
                              if (_selectedTable > 0 &&
                                  _selectedItems.isNotEmpty) {
                                orders[_selectedTable] = Order(
                                  type: OrderType.table,
                                  items: List.from(_selectedItems),
                                  isVeg: showVegOnly,
                                  table: tables.firstWhere(
                                    (t) => t.number == _selectedTable,
                                  ),
                                );
                              } else if (_selectedTable == 0 &&
                                  _selectedItems.isNotEmpty) {
                                // Save counter items
                                orders[0] = Order(
                                  type: OrderType.counter,
                                  isVeg: showVegOnly,
                                  items: List.from(_selectedItems),
                                );
                              }

                              // Switch to new table
                              _selectedTable = tableData.number;

                              // Load items for newly selected table
                              if (orders.containsKey(_selectedTable)) {
                                _selectedItems.clear();
                                _selectedItems.addAll(
                                  orders[_selectedTable]!.items,
                                );
                                showVegOnly = orders[_selectedTable]!.isVeg;
                              } else {
                                showVegOnly = true;
                                _selectedItems.clear();
                              }

                              // Update table status
                              tableData.status = _selectedItems.isNotEmpty
                                  ? Status.occupied
                                  : Status.free;
                            });
                          },
                          onDeselect: () {
                            setState(() {
                              // Save current items before deselecting
                              if (_selectedItems.isNotEmpty) {
                                orders[_selectedTable] = Order(
                                  type: OrderType.table,
                                  isVeg: showVegOnly,
                                  items: List.from(_selectedItems),
                                  table: tableData,
                                );
                                tableData.status = Status.occupied;
                              } else {
                                tableData.status = Status.free;
                              }

                              _selectedItems.clear();
                              showVegOnly = true;
                              _selectedTable = 0;
                            });
                          },
                          text: "Table ${tableData.number}",
                          isSelected: _selectedTable == tableData.number,
                          isOccupied: tableData.status == Status.occupied,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // 3. Right: Payment Summary
          Expanded(
            flex: 2,
            child: OrderSummaryPanel(
              selectedItems: _selectedItems,
              orderContext: _selectedTable > 0
                  ? "table" + _selectedTable.toString()
                  : "CounterOrder",
              onPaymentComplete: () {
                // ✅ Handle payment completion
                setState(() {
                  // Find and update the table status
                  if (_selectedTable > 0) {
                    final tableData = tables.firstWhere(
                      (t) => t.number == _selectedTable,
                    );
                    tableData.status = Status.free; // ✅ Mark as free
                    orders.remove(_selectedTable); // ✅ Clear the order
                  } else {
                    orders.remove(0); // ✅ Clear counter order
                  }

                  _selectedItems.clear(); // ✅ Clear items
                  _selectedTable = 0; // ✅ Deselect table
                });
              },
              onRemoveItem: (item) {
                setState(() => _selectedItems.remove(item));
              },
            ),
          ),
        ],
      ),
    );
  }
}
