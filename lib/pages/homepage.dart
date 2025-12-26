import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/category_selector.dart';
import '../components/filter_and_search_row.dart';
import '../components/menu_items_grid.dart';
import '../components/order_summary_panel.dart';
import '../components/tooglebtn.dart';
import '../models/menu_category.dart';
import '../models/menu_item.dart';
import 'loginpage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // MyHomePage
  final List<MenuItem> _selectedItems = [];
  late List<MenuCategory> categories;
  MenuCategory? selectedCategory;
  final List<MenuItem> selectedItems = [];
  bool showVegOnly = true;

  @override
  void initState() {
    super.initState();
    // Sample data - you can load this from API/database later
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
                    selectedItems: selectedItems,
                    onItemToggled: (item) {
                      setState(() {
                        if (selectedItems.contains(item)) {
                          selectedItems.remove(item);
                        } else {
                          selectedItems.add(item);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // 2. Middle: Selected Items Area
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    "TABLES",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 16),

                  // Tables to be added based on data of brand.
                  Expanded(child: Container()),

                  const SizedBox(height: 16),

                  // Big + button
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "+ ADD MORE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Right: Payment Summary
          Expanded(
            flex: 2,
            child: OrderSummaryPanel(
              selectedItems: selectedItems,
              onRemoveItem: (item) {
                setState(() => selectedItems.remove(item));
              },
          ),)
        ],
      ),
    );
  }
}
