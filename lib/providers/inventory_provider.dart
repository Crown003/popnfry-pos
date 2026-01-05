// providers/inventory_provider.dart
import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../services/firestore_service.dart';

class InventoryProvider extends ChangeNotifier {
  List<InventoryItem> _items = [];
  String _searchQuery = '';

  List<InventoryItem> get items {
    if (_searchQuery.isEmpty) {
      return _items;
    }
    return _items
        .where((item) =>
    item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        item.category.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  String get searchQuery => _searchQuery;

  // ============ SET ITEMS (Load from Firestore) ============
  void setItems(List<InventoryItem> newItems) {
    _items = newItems;
    notifyListeners();
  }

  // ============ ADD ITEM ============
  void addItem(InventoryItem item) {
    _items.add(item);
    notifyListeners();
  }

  // ============ UPDATE ITEM ============
  void updateItem(InventoryItem updatedItem) {
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      notifyListeners();
    }
  }

  // ============ DELETE ITEM ============
  Future<void> deleteItem(String itemId) async {
    try {
      // Delete from Firestore first
      await FirestoreService.deleteInventoryItem(itemId);

      // Remove from local list
      _items.removeWhere((item) => item.id == itemId);
      notifyListeners();

      print("✅ Item deleted from provider");
    } catch (e) {
      print("❌ Error deleting item: $e");
      rethrow;
    }
  }

  // ============ UPDATE SEARCH ============
  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // ============ CLEAR SEARCH ============
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}