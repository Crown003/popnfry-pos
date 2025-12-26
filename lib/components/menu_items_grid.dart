import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import 'menu_item_card.dart';

class MenuItemsGrid extends StatelessWidget {
  final List<MenuItem> items;
  final List<MenuItem> selectedItems;
  final Function(MenuItem) onItemToggled;

  const MenuItemsGrid({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onItemToggled,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Adjust for your screen (or use SliverGridDelegateWithMaxCrossAxisExtent)
        childAspectRatio: 0.8, // This is KEY — controls height vs width
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = selectedItems.contains(item);

        return MenuItemCard(
          item: item,
          isSelected: isSelected,
          onTap: () => onItemToggled(item),
        );
      },
    );
  }
}