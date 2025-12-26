import 'package:flutter/material.dart';
import 'menu_item.dart';

class MenuCategory {
  final String name;
  final IconData icon;
  final List<MenuItem> items;

  MenuCategory({
    required this.name,
    required this.icon,
    required this.items,
  });
}