import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/table.dart';
import '../providers/order_provider.dart';
import '../services/firestore_service.dart';
import 'selected_item_tile.dart';

class OrderSummaryPanel extends StatefulWidget {
  final String orderContext;
  final VoidCallback onPaymentComplete;
  final List<TableData> tables;

  const OrderSummaryPanel({
    super.key,
    required this.orderContext,
    required this.onPaymentComplete,
    required this.tables,
  });

  @override
  State<OrderSummaryPanel> createState() => _OrderSummaryPanelState();
}

class _OrderSummaryPanelState extends State<OrderSummaryPanel> {
  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    // Access the provider
    final Status? tableStatus;
    if (orderProvider.selectedTable > 0) {
      tableStatus = widget.tables
        .firstWhere((t) => t.number == orderProvider.selectedTable)
        .status;
    } else {
      tableStatus = null;
    }
    final bool isAlreadyBilled = tableStatus == Status.billed;
    final selectedItems = orderProvider.selectedItems;

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SELECTED (${selectedItems.length} for ${widget.orderContext})",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: selectedItems.isEmpty
                ? Center(
                    child: Text(
                      "No items selected",
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
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
                          widget.tables, // Passing tables list
                        ),
                        onQuantityChanged: (newQty) =>
                            orderProvider.updateItemQuantity(
                              item,
                              newQty,
                              widget.tables, // Pass tables list
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
                "₹${orderProvider.totalOrderAmount.toInt()}", // Using provider getter
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
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 8),
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
                  : () async {
                      // Professional Logging using Provider data
                      print("===========PopNFry=============");
                      print("Context: ${widget.orderContext}");
                      print("=== Selected Items ===");
                      for (var item in selectedItems) {
                        int qty = orderProvider.getItemQuantity(item);
                        print(
                          "${item.name} x$qty - ₹${(item.price * qty).toInt()}",
                        );
                      }
                      print(
                        "Total Items: ${selectedItems.fold<int>(0, (sum, item) => sum + orderProvider.getItemQuantity(item))}",
                      );
                      print(
                        "Total Price: ₹${orderProvider.totalOrderAmount.toInt()}",
                      );
                      print("======================");

                      // Show loading dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      try {
                        // Save order to Firestore
                        await FirestoreService.saveOrder(
                          tableNumber: orderProvider.selectedTable,
                          items: orderProvider.selectedItems,
                          quantities: orderProvider.quantities,
                          isVeg: orderProvider.selectedItems.every(
                            (item) => item.isVeg,
                          ),
                        );

                        // Close loading dialog
                        if (mounted) Navigator.pop(context);

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✅ Order saved successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        // Call callback and clear order
                        widget.onPaymentComplete();
                        orderProvider.clearOrder(widget.tables);
                      } catch (e) {
                        // Close loading dialog
                        if (mounted) Navigator.pop(context);

                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('❌ Error saving order: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        print("Error: $e");
                      }
                    },
              child: const Text(
                "PROCEED TO PAY",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
              ),
              onPressed: selectedItems.isEmpty
                  ? null
                  : (){
                orderProvider.onBillPrint(widget.tables);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🖨️ Bill Printed - Table marked as Billed'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              child: const Text(
                "Print Bill",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
