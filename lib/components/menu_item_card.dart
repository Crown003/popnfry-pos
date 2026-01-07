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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1.2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        color: Colors.grey[200],
                        child: Image.asset(
                          alignment: Alignment.center,
                          "assets/images/${item.imagePlaceholder}",
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                          cacheWidth: 250,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              alignment: Alignment.center,
                              cacheWidth: 250,
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // Price
                Text(
                  "₹${item.price.toInt()}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Check icon overlay
            if (isSelected)
              const Positioned(
                top: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}