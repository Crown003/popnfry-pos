import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class SelectedItemTile extends StatelessWidget {
  final MenuItem item;
  final int quantity;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;

  const SelectedItemTile({
    super.key,
    required this.item,
    required this.quantity,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              height: 50,
              width: 50,
              "assets/images/${item.imagePlaceholder}",
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  height: 50,
                  width: 50,
                  'assets/images/logo.png',
                );
              },
            ),

            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),

                  Text(
                    "₹${item.price.toInt()}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.remove, size: 16),
                          onPressed: () => onQuantityChanged(quantity - 1),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: Text(
                          "$quantity",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.add,
                            size: 16,
                            color: Colors.green,
                          ),
                          onPressed: () => onQuantityChanged(quantity + 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 30,
              height: 30,
              child: IconButton(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.red,
                ),
                onPressed: onRemove,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
