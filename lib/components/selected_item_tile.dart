import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class SelectedItemTile extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onRemove;

  const SelectedItemTile({
    super.key,
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      leading: Image.asset(
        "assets/images/${item.imagePlaceholder}",
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/logo.png', // Your fallback image
            fit: BoxFit.cover,
          );
        },
      ),
      title: Text(item.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "₹${item.price.toInt()}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
