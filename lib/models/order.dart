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
  Order({
    required this.type,
    required this.isVeg,
    required this.items,
    this.table,
  });
}
