import 'package:flutter/material.dart';
import 'package:possystem/models/menu_item.dart';
import 'package:possystem/providers/order_provider.dart';

class VariantPopup {
  static void showVariantPopup(
      BuildContext context,
      MenuItem item,
      OrderProvider orderProvider,
      ) {
    if (!item.haveVariants || item.variants == null || item.variants!.isEmpty) {
      orderProvider.addItem(item);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        Variant? selectedVariant;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey[50]!,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2C2C2C),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Choose your preferred variant',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                              ),
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Text(
                        'Available Variants',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 16),

                      SingleChildScrollView(
                        child: Column(
                          children: item.variants!.map((variant) {
                            final isSelected = selectedVariant == variant;
                            return GestureDetector(
                              onTap: () {
                                setState(() => selectedVariant = variant);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFFF6B6B)
                                        : Colors.grey[200]!,
                                    width: isSelected ? 2 : 1.5,
                                  ),
                                  color: isSelected
                                      ? const Color(0xFFFF6B6B)
                                      : Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      variant.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? const Color(0xFFFFffff)
                                            : Colors.grey[800],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        color: isSelected
                                            ? const Color(0xFFFF6B6B)
                                            : Colors.grey[100],
                                      ),
                                      child: Text(
                                        '${variant.symbol}${variant.price}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected
                                              ? Colors.white
                                              : const Color(0xFFFF6B6B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6), // ⬅ reduced radius
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: selectedVariant == null
                                  ? null
                                  : () {
                                final updatedItem = MenuItem(
                                  name: "${item.name}(${selectedVariant!.symbol})",
                                  price: selectedVariant!.price.toDouble(),
                                  imagePlaceholder:
                                  item.imagePlaceholder,
                                  isVeg: item.isVeg,
                                  haveVariants: false,
                                  variants: null,
                                );
                                orderProvider.addItem(updatedItem);
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6), // ⬅ reduced radius
                                ),
                              ),
                              child: const Text('Add to Order'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ), // ✅ Container closed
            ); // ✅ Dialog closed
          },
        );
      },
    );
  }
}
