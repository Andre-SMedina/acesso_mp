import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function() callback;
  final String text;
  const MyButton({super.key, required this.callback, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return const Color(0xFFB4B4B4);
              }
              return const Color(0xFF053F63);
            })),
        onPressed: callback,
        child: Text(text, style: const TextStyle(color: Colors.white)));
  }
}
