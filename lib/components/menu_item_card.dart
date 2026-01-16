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

  Widget _buildItemImage() {
    final path = item.imagePlaceholder;

    // Case 1: No path → fallback
    if (path == null || path.trim().isEmpty) {
      return _fallbackImage();
    }
    // Case 2: It's a network URL
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        },
        errorBuilder: (context, error, stackTrace) => _fallbackImage(),
      );
    }

    // Case 3: Assume it's a local asset name (without "assets/images/" prefix)
    return Image.asset(
      "assets/images/$path",
      fit: BoxFit.contain,
      width: double.infinity,
      height: double.infinity,
      cacheWidth: 250,
      errorBuilder: (context, error, stackTrace) => _fallbackImage(),
    );
  }

  Widget _fallbackImage() {
    return Image.asset(
      'assets/images/logo.png',
      fit: BoxFit.contain,
      width: double.infinity,
      height: double.infinity,
      cacheWidth: 250,
    );
  }

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
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
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
                        child: _buildItemImage(),
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
              ],
            ),

            // Veg/Non-Veg indicator
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: item.isVeg ? Colors.green : Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.all(2.5),
                child: Container(
                  decoration: BoxDecoration(
                    color: item.isVeg ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            // Selected checkmark
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