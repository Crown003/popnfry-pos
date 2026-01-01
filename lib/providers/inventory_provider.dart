// providers/inventory_provider.dart
import 'package:flutter/material.dart';
import '../models/inventory_item.dart';

class InventoryProvider extends ChangeNotifier {
  List<InventoryItem> _items = [
    InventoryItem(
      id: '1',
      name: 'Tomato',
      category: 'Vegetables',
      stock: 15,
      lowStockThreshold: 20,
      purchasePrice: 40,
      sellingPrice: 60,
    ),
    InventoryItem(
      id: '2',
      name: 'Cheese',
      category: 'Dairy',
      stock: 5,
      lowStockThreshold: 10,
      purchasePrice: 200,
      sellingPrice: 280,
    ),
    InventoryItem(
      id: '3',
      name: 'Pizza Base',
      category: 'Bakery',
      stock: 30,
      lowStockThreshold: 15,
      purchasePrice: 50,
      sellingPrice: 80,
    ),
    InventoryItem(
      id: '4',
      name: 'Olive Oil',
      category: 'Oils',
      stock: 8,
      lowStockThreshold: 10,
      purchasePrice: 500,
      sellingPrice: 650,
    ),
    // Add more dummy items...
  ];

  String _searchQuery = '';

  List<InventoryItem> get items {
    if (_searchQuery.isEmpty) return _items;
    return _items.where((item) =>
    item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        item.category.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addItem(InventoryItem item) {
    _items.add(item);
    notifyListeners();
  }

  void updateStock(String id, int newStock) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = InventoryItem(
        id: _items[index].id,
        name: _items[index].name,
        category: _items[index].category,
        stock: newStock,
        lowStockThreshold: _items[index].lowStockThreshold,
        purchasePrice: _items[index].purchasePrice,
        sellingPrice: _items[index].sellingPrice,
      );
      notifyListeners();
    }
  }

  void updateItem(InventoryItem updatedItem) {
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      notifyListeners();
    }
  }

  void deleteItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}