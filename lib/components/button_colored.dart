import 'package:flutter/material.dart';

class button_colored extends StatelessWidget {
  const button_colored(
      {super.key, required this.text, required this.isSelected});

  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chip(
        backgroundColor: isSelected ? Colors.black : Colors.blue,
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
