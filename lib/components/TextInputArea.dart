import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextInputArea extends StatelessWidget {
  const TextInputArea({
    super.key,
    required this.label,
    this.isPassword = false,
    this.TextEditingController,
    this.maxLines = 1,
    required this.icon,
    this.type = TextInputType.text,
    this.autocorrect = false,
    this.maxLen = 20,
    this.isForOnlyRead = false,
    this.typeOfTextAreaToValidate = "text",
  });

  final label;
  final bool isForOnlyRead;
  final String typeOfTextAreaToValidate;
  final int maxLines;
  final bool isPassword;
  final TextEditingController;
  final TextInputType type;
  final int maxLen;
  final Icon icon;
  final bool autocorrect;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: type,
      autocorrect: autocorrect,
      readOnly: isForOnlyRead,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          labelText: label,
          prefixIcon: icon,

          // ignore: prefer_const_constructors
          suffixIcon: isPassword ? Icon(Icons.remove_red_eye_outlined) : null),
      obscureText: isPassword,
      controller: TextEditingController,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label cannot be empty';
        } else {
          if (typeOfTextAreaToValidate == "email" && !value.contains('@')) {
            return 'Please enter a valid $typeOfTextAreaToValidate';
          }
          if (typeOfTextAreaToValidate == "password" && value.length < 6) {
            return 'Password must be at least 6 characters';
          } 
        }
      },
    );
  }
}
