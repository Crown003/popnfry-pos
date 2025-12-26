import 'package:flutter/material.dart';
import '../models/menu_category.dart';
import '../models/menu_item.dart';
import '../components/category_selector.dart';
import '../components/filter_and_search_row.dart';
import '../components/menu_items_grid.dart';
import '../components/order_summary_panel.dart';

class POSHomeScreen extends StatefulWidget {
  const POSHomeScreen({super.key});

  @override
  State<POSHomeScreen> createState() => _POSHomeScreenState();
}

class _POSHomeScreenState extends State<POSHomeScreen> {
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
          MenuItem(name: "Margherita", price: 180, imagePlaceholder: "", isVeg: true),
          MenuItem(name: "Farm Fresh", price: 220, imagePlaceholder: "", isVeg: true),
          MenuItem(name: "Chicken Tikka", price: 320, imagePlaceholder: "", isVeg: false),
        ],
      ),
      MenuCategory(
        name: "Burgers",
        icon: Icons.fastfood,
        items: [
          MenuItem(name: "Veg Maharaja", price: 150, imagePlaceholder: "", isVeg: true),
          MenuItem(name: "Chicken Maharaja", price: 190, imagePlaceholder: "", isVeg: false),
        ],
      ),
      MenuCategory(
        name: "Sides",
        icon: Icons.favorite_border,
        items: [
          MenuItem(name: "Garlic Bread", price: 120, imagePlaceholder: "", isVeg: true),
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

  @override
  Widget build(BuildContext context) {
    final currentItems = _getFilteredItems();

    return Scaffold(
      body: Row(
        children: [
          // Left - Categories + Items
          Expanded(
            flex: 6,
            child: Column(
              children: [
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

          // Right - Order Summary
          Expanded(
            flex: 3,
            child: OrderSummaryPanel(
              selectedItems: selectedItems,
              onRemoveItem: (item) {
                setState(() => selectedItems.remove(item));
              },
            ),
          ),
        ],
      ),
    );
  }
}