import 'package:flutter/material.dart';

class Card extends StatefulWidget {
  const Card({super.key});
  @override
  State<Card> createState() => _CardState();
}
class _CardState extends State<Card> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: 30,
            padding: const EdgeInsets.symmetric(vertical:2.0,horizontal:2.0),
            color: Colors.redAccent,
            child: Image.asset("assets/images/logo.png")
        )
    );
  }
}
