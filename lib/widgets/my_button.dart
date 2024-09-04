import 'package:acesso_mp/helpers/std_values.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {super.key, required this.callback, required this.text, this.icon});
  final void Function() callback;
  final String text;
  final IconData? icon;

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
                return StdValues.hoverGrey;
              }
              return StdValues.btnBlue;
            })),
        onPressed: callback,
        child: (icon != null)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(text,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16)),
                ],
              )
            : Text(text,
                style: const TextStyle(color: Colors.white, fontSize: 16)));
  }
}
