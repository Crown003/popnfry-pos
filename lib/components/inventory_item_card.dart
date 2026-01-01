// components/inventory_item_card.dart
import 'package:flutter/material.dart';
import '../models/inventory_item.dart';

// components/inventory_item_card.dart
class InventoryItemCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const InventoryItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: item.isLowStock ? Colors.red.shade300 : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      color: item.isLowStock ? Colors.red.shade50 : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (item.isLowStock)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                            child: const Text('LOW STOCK', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(item.category, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoChip('Stock', '${item.stock}', item.isLowStock ? Colors.red.shade700 : Colors.black87),
                        _buildInfoChip('Buy', '₹${item.purchasePrice.toInt()}', Colors.blueGrey),
                        _buildInfoChip('Sell', '₹${item.sellingPrice.toInt()}', Colors.green),
                        _buildInfoChip('Profit', '+₹${item.profit.toInt()}', Colors.green.shade700),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Margin: ${item.profitPercentage.toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 13, color: Colors.green.shade600, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
                  IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}