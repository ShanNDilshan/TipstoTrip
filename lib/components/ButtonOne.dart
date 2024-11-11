import 'package:flutter/material.dart';

class ButtonOne extends StatelessWidget {
  const ButtonOne({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.textColor,
  });
  final String label;
  final Icon icon;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 226, 225, 225),
                spreadRadius: 5,
                blurRadius: 5)
          ],
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [],
                    color: Color.fromRGBO(35, 237, 252, 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: icon,
                  )),
            ],
          ),
        ));
  }
}
