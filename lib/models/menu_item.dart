class Variant {
  final String name;
  final int price;
  final String symbol;

  Variant({
    required this.name,
    required this.price,
    required this.symbol,
  });

  factory Variant.fromMap(Map<String, dynamic> map) {
    return Variant(
      name: map['name'] ?? '',
      price: (map['price'] ?? 0) as int,
      symbol: map['symbol'] ?? '',
    );
  }
}

class MenuItem {
  final String name;
  final double price;
  final String imagePlaceholder;
  final bool isVeg;
  final bool haveVariants;
  final List<Variant>? variants;

  MenuItem({
    required this.name,
    required this.price,
    required this.imagePlaceholder,
    required this.isVeg,
    required this.haveVariants,
    this.variants,
  });
}
