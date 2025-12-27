// import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

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

  static CustomButton(VoidCallback voidCallback, String text) {
    return SizedBox(
      height: 50,
      width: 300,
      child: ElevatedButton(
        onPressed: () {
          voidCallback();
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 20)),
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
    required bool isOccupied,
    required VoidCallback onSelect,
    required VoidCallback onDeselect,
    required String text,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        if (isSelected) {
          onDeselect();  // Deselect if already selected
        } else {
          onSelect();    // Select if not selected
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.green.shade100
              : isOccupied
              ? Colors.yellow.shade100
              : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
              color: isSelected ? Colors.green : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
