import 'package:flutter/material.dart';

class MyFormfield extends StatelessWidget {
  final void Function(String) call;
  final TextEditingController controller;
  final String text;
  final String erroText;
  final bool passwd;
  final IconButton? iconBtn;
  final Icon? icon;
  const MyFormfield(
      {super.key,
      required this.text,
      this.iconBtn,
      this.passwd = false,
      this.icon,
      required this.controller,
      required this.erroText,
      required this.call});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: passwd,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 15),
        labelText: text,
        helperText: '',
        labelStyle: const TextStyle(color: Color.fromARGB(255, 116, 116, 116)),
        suffixIcon: (icon != null) ? icon : iconBtn,
        fillColor: const Color.fromARGB(255, 234, 234, 234),
        filled: true,
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onFieldSubmitted: call,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return erroText;
        }
        return null;
      },
    );
  }
}
