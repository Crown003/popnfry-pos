import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const MenuItemCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(8), // Consistent padding
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: 1,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey,
          //     blurRadius: 4,
          //     offset: const Offset(0, 2),
          //   ),
          // ],
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Important: prevents taking full height
          children: [
            // Image placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                "assets/images/${item.imagePlaceholder}",
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/logo.png', // Your fallback image
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Item name - wrapped to prevent overflow
            Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis, // Handles long names gracefully
            ),
            const SizedBox(height: 4),
            // Price
            Text(
              "₹${item.price.toInt()}",
              style: const TextStyle(
                color: Colors.green,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Selected indicator
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Icon(Icons.check_circle, color: Colors.green, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
