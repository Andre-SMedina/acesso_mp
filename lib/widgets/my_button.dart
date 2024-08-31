import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  const MyButton({super.key, required this.callback, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        onPressed: callback,
        child: Text(text, style: const TextStyle(color: Colors.white)));
  }
}
