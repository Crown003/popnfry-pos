// models/inventory_item.dart
class InventoryItem {
  final String id;
  final String name;
  final String category;
  final int stock;
  final int lowStockThreshold;
  final double purchasePrice;
  final double sellingPrice;
  final DateTime? lastUpdated; // Optional

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.lowStockThreshold,
    required this.purchasePrice,
    required this.sellingPrice,
    this.lastUpdated,
  });

  double get profit => sellingPrice - purchasePrice;
  double get profitPercentage => purchasePrice > 0 ? (profit / purchasePrice) * 100 : 0;

  bool get isLowStock => stock <= lowStockThreshold;

  InventoryItem copyWith({
    String? id,
    String? name,
    String? category,
    int? stock,
    int? lowStockThreshold,
    double? purchasePrice,
    double? sellingPrice,
    DateTime? lastUpdated,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}