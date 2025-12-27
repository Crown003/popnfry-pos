import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import 'selected_item_tile.dart';

class OrderSummaryPanel extends StatefulWidget {
  final List<MenuItem> selectedItems;
  final String orderContext;
  final ValueChanged<MenuItem> onRemoveItem;
  final VoidCallback onPaymentComplete;
  const OrderSummaryPanel({
    super.key,
    required this.selectedItems,
    required this.onRemoveItem,
    required this.orderContext,
    required this.onPaymentComplete,
  });

  @override
  State<OrderSummaryPanel> createState() => _OrderSummaryPanelState();
}
class _OrderSummaryPanelState extends State<OrderSummaryPanel> {
  final Map<MenuItem, int> _quantities = {};

  @override
  void didUpdateWidget(covariant OrderSummaryPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (var item in widget.selectedItems){
      _quantities.putIfAbsent(item, () => 1);
    }
    //clean up removed items
    _quantities.removeWhere((key, value) => !widget.selectedItems.contains(key));
  }

  int getQuantity(MenuItem item) => _quantities[item] ?? 1;

  void updateQuantity(MenuItem item, int newQuantity){
    if(newQuantity <= 0){
      widget.onRemoveItem(item);
      return;
    }
    setState(() {
      _quantities[item] = newQuantity;
    });
  }
    //to calculate the total amount
  double get total{
    return widget.selectedItems.fold<double>(0.0, (sum, item) => sum + (item.price * getQuantity(item)));
  }

    @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SELECTED (${widget.selectedItems.length} for ${widget.orderContext})",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: widget.selectedItems.length,
              itemBuilder: (context, index) {
                final item = widget.selectedItems[index];
                return SelectedItemTile(
                  item: item,
                  quantity: getQuantity(item),
                  onRemove: () => widget.onRemoveItem(item),
                  onQuantityChanged: (newQty) => updateQuantity(item, newQty),
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
              onPressed: widget.selectedItems.isEmpty
                  ? null
                  : () {

                print("===========PopNFry=============");
                      print("${widget.orderContext}");
                      print("=== Selected Items ===");
                      for (var item in widget.selectedItems) {
                        print("${item.name} - ₹${item.price.toInt()}");
                      }
                      print("Total items: ${widget.selectedItems.length}");
                      // Optional: calculate and print total price
                      double total = widget.selectedItems.fold(
                        0,
                        (sum, item) => sum + item.price,
                      );
                      print("Total Price: ₹${total.toInt()}");
                      print("======================");
                      widget.onPaymentComplete();
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
