import 'package:flutter/material.dart';
import 'package:possystem/providers/order_provider.dart';

class DiscountDialog {
  static void show(
      BuildContext context,
      OrderProvider orderProvider,
      ) {
    final subtotal = orderProvider.getSubtotal();
    bool usePercentage = orderProvider.usePercentageDiscount;

    final valueCtrl = TextEditingController(
      text: usePercentage
          ? orderProvider.discountPercentage.toString()
          : orderProvider.discountAmount.toString(),
    );

    final reasonCtrl =
    TextEditingController(text: orderProvider.discountReason ?? '');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 4,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Apply Discount',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Adjust your total amount',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey[400],
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Subtotal Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.blue[100]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '₹${subtotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Discount Type Label
                    Text(
                      'Select Discount Type',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Discount Type Toggle
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => usePercentage = true),
                            child: Container(
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: usePercentage
                                      ? Colors.blue[300]!
                                      : Colors.grey[200]!,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: usePercentage
                                    ? Colors.blue[50]
                                    : Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  'Percentage',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: usePercentage
                                        ? Colors.blue[700]
                                        : Colors.grey[500],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => usePercentage = false),
                            child: Container(
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: !usePercentage
                                      ? Colors.green[300]!
                                      : Colors.grey[200]!,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: !usePercentage
                                    ? Colors.green[50]
                                    : Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  'Fixed Amount',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: !usePercentage
                                        ? Colors.green[700]
                                        : Colors.grey[500],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Discount Value Input
                    TextField(
                      controller: valueCtrl,
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText:
                        usePercentage ? 'Enter Discount %' : 'Enter Amount ₹',
                        labelStyle: TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          BorderSide(color: Colors.grey[200]!, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          BorderSide(color: Colors.grey[200]!, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: usePercentage
                                ? Colors.blue[400]!
                                : Colors.green[400]!,
                            width: 2,
                          ),
                        ),
                        prefixIcon: Icon(
                          usePercentage ? Icons.percent : Icons.currency_rupee,
                          color: usePercentage
                              ? Colors.blue[500]
                              : Colors.green[500],
                          size: 20,
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Reason Input
                    TextField(
                      controller: reasonCtrl,
                      decoration: InputDecoration(
                        labelText: 'Reason (Optional)',
                        labelStyle: TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        hintText: 'e.g., Loyalty, Promotion',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          BorderSide(color: Colors.grey[200]!, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          BorderSide(color: Colors.grey[200]!, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.note_outlined,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Summary Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.green[100]!,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discount:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '₹${(usePercentage
                                    ? (subtotal *
                                    (double.tryParse(
                                        valueCtrl.text) ??
                                        0) /
                                    100)
                                    .clamp(0, subtotal)
                                    : (double.tryParse(valueCtrl.text) ?? 0)
                                    .clamp(0, subtotal))
                                    .toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Divider(
                            color: Colors.green[200],
                            height: 1,
                            thickness: 1,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Final Total:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              Text(
                                '₹${(subtotal - (usePercentage ? (subtotal * (double.tryParse(valueCtrl.text) ?? 0) / 100).clamp(0, subtotal) : (double.tryParse(valueCtrl.text) ?? 0).clamp(0, subtotal)))
                                    .toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              orderProvider.clearDiscount();
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Clear',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final value =
                                  double.tryParse(valueCtrl.text) ?? 0;
                              final reason = reasonCtrl.text.trim().isEmpty
                                  ? null
                                  : reasonCtrl.text.trim();

                              if (usePercentage) {
                                orderProvider.setPercentageDiscount(value,
                                    reason: reason);
                              } else {
                                orderProvider.setFixedDiscount(value,
                                    reason: reason);
                              }

                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: const Color(0xFF16A34A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Apply Discount',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}