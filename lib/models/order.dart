import 'package:possystem/models/menu_item.dart';
import 'package:possystem/models/table.dart';

enum OrderType {
  counter,
  table
}

class Order {
  final OrderType type;
  final bool isVeg;
  final List<MenuItem> items;
  final TableData? table;
  final Map<MenuItem, int>? quantities;  // ✅ Optional - backward compatible

  Order({
    required this.type,
    required this.isVeg,
    required this.items,
    this.table,
    this.quantities,  // ✅ Optional parameter
  });

  // ✅ Safe getter - returns 1 if quantity not found
  int getQuantity(MenuItem item) {
    return quantities?[item] ?? 1;
  }

  // ✅ Calculate total with quantities
  double getTotal() {
    double total = 0.0;
    for (var item in items) {
      total += item.price * getQuantity(item);
    }
    return total;
  }
}