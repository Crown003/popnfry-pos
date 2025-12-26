import 'package:flutter/material.dart';
import '../models/menu_category.dart';

class CategorySelector extends StatelessWidget {
  final List<MenuCategory> categories;
  final MenuCategory? selectedCategory;
  final ValueChanged<MenuCategory> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.all(4),
            child: FilterChip(
              selected: isSelected,
              showCheckmark: false,
              avatar: Icon(
                category.icon,
                size: 20,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
              label: Text(category.name),
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.deepOrange,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (_) => onCategorySelected(category),
            ),
          );
        },
      ),
    );
  }
}