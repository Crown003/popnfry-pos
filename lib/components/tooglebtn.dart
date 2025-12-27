import 'package:flutter/material.dart';

class VegNonVegToggle extends StatefulWidget {
  final bool initialValue; // true = Veg, false = Non-Veg
  final ValueChanged<bool> onChanged;

  const VegNonVegToggle({
    super.key,
    this.initialValue = true,
    required this.onChanged,
  });
  @override
  State<VegNonVegToggle> createState() => _VegNonVegToggleState();
}
class _VegNonVegToggleState extends State<VegNonVegToggle> {
  late bool isVeg;

  @override
  void initState() {
    super.initState();
    isVeg = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isVeg = !isVeg;
        });
        widget.onChanged(isVeg);
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // VEG button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isVeg ? Colors.green : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: isVeg ? Colors.white : Colors.green,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "VEG",
                    style: TextStyle(
                      color: isVeg ? Colors.white : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // NON-VEG button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: !isVeg ? Colors.red : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: !isVeg ? Colors.white : Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "NON-VEG",
                    style: TextStyle(
                      color: !isVeg ? Colors.white : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}