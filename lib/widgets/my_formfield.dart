import 'package:flutter/material.dart';

class MyFormfield extends StatelessWidget {
  final String text;
  final Icon? icon;
  const MyFormfield({super.key, required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: text,
          suffixIcon: icon,
          fillColor: Color(0xFFF5F5F5),
          filled: true),
    );
  }
}
