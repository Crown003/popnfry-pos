import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Make sure to import provider
import '../models/menu_item.dart';
import '../providers/order_provider.dart'; // Import your provider file
import 'selected_item_tile.dart';

class OrderSummaryPanel extends StatelessWidget {
  final String orderContext;
  final VoidCallback onPaymentComplete;

  const OrderSummaryPanel({
    super.key,
    required this.orderContext,
    required this.onPaymentComplete,
  });

  @override
  Widget build(BuildContext context) {
    // Access the provider
    final orderProvider = context.watch<OrderProvider>();
    final selectedItems = orderProvider.selectedItems;
    final tables = []; // If you have a tables list globally, pass it here or get it from provider

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SELECTED (${selectedItems.length} for $orderContext)",
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
                  // Use the new provider methods
                  quantity: orderProvider.getItemQuantity(item),
                  onRemove: () => orderProvider.removeItem(item, []), // Pass tables list if needed
                  onQuantityChanged: (newQty) =>
                      orderProvider.updateItemQuantity(item, newQty, []),
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
                "₹${orderProvider.totalOrderAmount.toInt()}", // Using provider getter
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
                // Professional Logging using Provider data
                print("===========PopNFry=============");
                print("Context: $orderContext");
                print("=== Selected Items ===");
                for (var item in selectedItems) {
                  int qty = orderProvider.getItemQuantity(item);
                  print("${item.name} x $qty - ₹${(item.price * qty).toInt()}");
                }
                print("Total Price: ₹${orderProvider.totalOrderAmount.toInt()}");
                print("======================");

                onPaymentComplete();
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