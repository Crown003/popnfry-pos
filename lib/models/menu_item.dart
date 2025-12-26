class MenuItem {
  final String name;
  final double price;
  final String imagePlaceholder; // can be asset path or network url later
  final bool isVeg;

  MenuItem({
    required this.name,
    required this.price,
    required this.imagePlaceholder,
    required this.isVeg,
  });
}