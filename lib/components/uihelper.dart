import "package:flutter/material.dart";

import "../models/table.dart";

class Helper {
  static CustomTextField(
    TextEditingController controller,
    String text,
    IconData iconData,
    bool toHide,
  ) {
    return TextField(
      controller: controller,
      obscureText: toHide,
      decoration: InputDecoration(
        hintText: text,
        suffixIcon: Icon(iconData),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  static CustomButton(VoidCallback? voidCallback, String text) {
    return SizedBox(
      height: 50,
      width: 300,
      child: ElevatedButton(
        onPressed: voidCallback, // Disable button if voidCallback is null (loading state)
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          disabledBackgroundColor: Colors.grey[400], // Lighter color when disabled
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
  static showAlert({required BuildContext context, required String title}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(title),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("ok"),
            ),
          ],
        );
      },
    );
  }

  static Widget CustomTableCard({
    required Status status,
    required VoidCallback onSelect,
    required VoidCallback onDeselect,
    required String text,
    required bool isSelected,
    required String tableTotal,
  }) {
    Color bgColor;
    Color borderColor;

    if (isSelected) {
      bgColor = Colors.green.shade100;
      borderColor = Colors.green;
    }
    else {
      switch (status) {
        case Status.free:
          bgColor = Colors.white;
          borderColor = Colors.grey.shade300;
          break;
        case Status.occupied:
          bgColor = Colors.yellow.shade100;
          borderColor = Colors.orange;
          break;
        case Status.billed:
          bgColor = Colors.blue.shade100;
          borderColor = Colors.blue;
          break;
      }
    }

    return InkWell(
      onTap: () {
        if (isSelected) {
          onDeselect();
        } else {
          onSelect();
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Table name
              Text(
                text,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                  color: borderColor,
                ),
              ),

              /// Total amount
              if (tableTotal.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    tableTotal,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: borderColor,
                    ),
                  ),
                ),

              if (status == Status.billed)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(
                    Icons.receipt_long,
                    size: 16,
                    color: Colors.blue,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
