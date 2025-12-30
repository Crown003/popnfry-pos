import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/menu_item.dart';
import '../models/table.dart';

class OrderProvider extends ChangeNotifier {
  Map<int, Order> orders = {};
  int selectedTable = 0;
  List<MenuItem> selectedItems = [];
  bool showVegOnly = true;
  String searchQuery = '';

  // A separate map just to track quantities
  final Map<MenuItem, int> _itemQuantities = {};

  // Getter for the UI to display the total
  double get totalOrderAmount {
    double total = 0.0;
    for (var item in selectedItems) {
      total += item.price * (getItemQuantity(item));
    }
    return total;
  }

  // Helper to get quantity (defaults to 1 if not set)
  int getItemQuantity(MenuItem item) => _itemQuantities[item] ?? 1;

  // For the + and - buttons in your summary panel
  void updateItemQuantity(MenuItem item, int newQuantity, List<TableData> tables) {
    if (newQuantity <= 0) {
      removeItem(item, tables);
    } else {
      _itemQuantities[item] = newQuantity;
      notifyListeners();
    }
  }

  // Add item to order
  void addItem(MenuItem item) {
    if (!selectedItems.contains(item)) {
      selectedItems.add(item);
      _itemQuantities[item] = 1;
      notifyListeners();
    }
  }

  // Select/switch table
  void selectTable(int tableNumber, List<TableData> tables) {
    // Save or clear current table's order before switching
    if (selectedTable > 0) {
      final tableData = tables.firstWhere((t) => t.number == selectedTable);
      if (selectedItems.isNotEmpty) {
        orders[selectedTable] = Order(
          type: OrderType.table,
          items: List.from(selectedItems),
          isVeg: showVegOnly,
          table: tableData,
        );
        tableData.status = Status.occupied;
      } else {
        orders.remove(selectedTable);
        tableData.status = Status.free;
      }
    } else if (selectedTable == 0) {
      // Counter: save or clear
      if (selectedItems.isNotEmpty) {
        orders[0] = Order(
          type: OrderType.counter,
          isVeg: showVegOnly,
          items: List.from(selectedItems),
        );
      } else {
        orders.remove(0);
      }
    }

    // Switch to new table
    selectedTable = tableNumber;

    // Load existing order if any
    if (orders.containsKey(selectedTable)) {
      final order = orders[selectedTable]!;
      selectedItems = List.from(order.items);
      showVegOnly = order.isVeg;

      // Rebuild quantities map from loaded items
      _itemQuantities.clear();
      for (var item in selectedItems) {
        _itemQuantities[item] = 1;
      }

      if (selectedTable > 0 && selectedItems.isNotEmpty) {
        final tableData = tables.firstWhere((t) => t.number == selectedTable);
        tableData.status = Status.occupied;
      }
    } else {
      selectedItems = [];
      _itemQuantities.clear();
      showVegOnly = true;
    }

    notifyListeners();
  }

  // Deselect table
  void deselectTable(int tableNumber, List<TableData> tables) {
    if (selectedTable > 0) {
      final tableData = tables.firstWhere((t) => t.number == selectedTable);

      if (selectedItems.isNotEmpty) {
        orders[selectedTable] = Order(
          type: OrderType.table,
          isVeg: showVegOnly,
          items: List.from(selectedItems),
          table: tableData,
        );
        tableData.status = Status.occupied;
      } else {
        orders.remove(selectedTable);
        tableData.status = Status.free;
      }
    } else {
      // For counter
      if (selectedItems.isNotEmpty) {
        orders[0] = Order(
          type: OrderType.counter,
          isVeg: showVegOnly,
          items: List.from(selectedItems),
        );
      } else {
        orders.remove(0);
      }
    }

    selectedItems = [];
    _itemQuantities.clear();
    selectedTable = 0;
    showVegOnly = true;
    notifyListeners();
  }

  double getTableTotal(int tableNumber) {
    final order = orders[tableNumber];
    if (order == null || order.items.isEmpty) {
      return 0.0;
    }
    return order.items.fold(0.0, (sum, item) => sum + item.price);
  }

  // FIXED: Remove item with proper state cleanup
  void removeItem(MenuItem item, List<TableData> tables) {
    // 1. Remove from the selected items
    selectedItems.remove(item);

    // 2. Remove from quantities map
    _itemQuantities.remove(item);

    // 3. If it was the last item, clean up properly
    if (selectedItems.isEmpty) {
      if (selectedTable > 0) {
        final tableData = tables.firstWhere((t) => t.number == selectedTable);
        orders.remove(selectedTable);
        tableData.status = Status.free;
      } else {
        orders.remove(0); // Counter order
      }

      // Reset state for empty order
      selectedTable = 0;
      showVegOnly = true;
    }

    // Always notify listeners - this ensures UI updates
    notifyListeners();
  }

  // Toggle veg filter
  void toggleVegFilter(bool value) {
    showVegOnly = value;
    notifyListeners();
  }

  // Clear order (for payment completion)
  void clearOrder(List<TableData> tables) {
    if (selectedTable > 0) {
      final tableData = tables.firstWhere((t) => t.number == selectedTable);
      tableData.status = Status.free;
      orders.remove(selectedTable);
    } else {
      orders.remove(0);
    }

    selectedItems = [];
    _itemQuantities.clear();
    selectedTable = 0;
    showVegOnly = false;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    searchQuery = '';
    notifyListeners();
  }
}