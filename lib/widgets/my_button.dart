import 'package:acesso_mp/helpers/std_values.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function() callback;
  final String text;
  const MyButton({super.key, required this.callback, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            minimumSize: WidgetStateProperty.all(const Size(150, 50)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return (text == 'Limpar')
                    ? const Color.fromARGB(255, 244, 41, 41)
                    : StdValues.hoverGrey;
              }
              return StdValues.btnBlue;
            })),
        onPressed: callback,
        child: Text(text,
            style: const TextStyle(color: Colors.white, fontSize: 16)));
  }
}
