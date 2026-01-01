import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../models/table.dart';
import '../providers/order_provider.dart';
import 'selected_item_tile.dart';

class OrderSummaryPanel extends StatelessWidget {
  final String orderContext;
  final VoidCallback onPaymentComplete;
  final List<TableData> tables;  // ✅ Add this parameter

  const OrderSummaryPanel({
    super.key,
    required this.orderContext,
    required this.onPaymentComplete,
    required this.tables,  // ✅ Add this
  });

  @override
  Widget build(BuildContext context) {
    // Access the provider
    final orderProvider = context.watch<OrderProvider>();
    final selectedItems = orderProvider.selectedItems;

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
            child: selectedItems.isEmpty
                ? Center(
              child: Text(
                "No items selected",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              itemCount: selectedItems.length,
              itemBuilder: (context, index) {
                final item = selectedItems[index];
                return SelectedItemTile(
                  item: item,
                  // Use the new provider methods
                  quantity: orderProvider.getItemQuantity(item),
                  onRemove: () => orderProvider.removeItem(
                    item,
                    tables,  // ✅ Pass tables list
                  ),
                  onQuantityChanged: (newQty) =>
                      orderProvider.updateItemQuantity(
                        item,
                        newQty,
                        tables,  // ✅ Pass tables list
                      ),
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
                "₹${orderProvider.totalOrderAmount.toInt()}",  // ✅ Using provider getter
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Items: ${selectedItems.fold<int>(0, (sum, item) => sum + orderProvider.getItemQuantity(item))}",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
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
                  print("${item.name} x$qty - ₹${(item.price * qty).toInt()}");
                }
                print("Total Items: ${selectedItems.fold<int>(0, (sum, item) => sum + orderProvider.getItemQuantity(item))}");
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