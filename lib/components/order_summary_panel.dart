import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import 'selected_item_tile.dart';

class OrderSummaryPanel extends StatelessWidget {
  final List<MenuItem> selectedItems;
  final ValueChanged<MenuItem> onRemoveItem;

  const OrderSummaryPanel({
    super.key,
    required this.selectedItems,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    final total = selectedItems.fold<double>(
      0,
      (sum, item) => sum + item.price,
    );

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SELECTED (${selectedItems.length})",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: selectedItems.length,
              itemBuilder: (context, index) {
                final item = selectedItems[index];
                return SelectedItemTile(
                  item: item,
                  onRemove: () => onRemoveItem(item),
                );
              },
            ),
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "TOTAL",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "₹${total.toInt()}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
              onPressed: selectedItems.isEmpty
                  ? null
                  : () {
                      print("=== Selected Items ===");
                      for (var item in selectedItems) {
                        print("${item.name} - ₹${item.price.toInt()}");
                      }
                      print("Total items: ${selectedItems.length}");
                      // Optional: calculate and print total price
                      double total = selectedItems.fold(
                        0,
                        (sum, item) => sum + item.price,
                      );
                      print("Total Price: ₹${total.toInt()}");
                      print("======================");
                    },
              child: const Text(
                "PROCEED TO PAY",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
