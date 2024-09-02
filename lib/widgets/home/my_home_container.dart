import 'package:flutter/material.dart';

class MyHomeContainer extends StatelessWidget {
  final Widget child;
  const MyHomeContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - 340;

    return Container(
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 178, 178, 178),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 5))
          ],
          color: const Color.fromARGB(255, 225, 225, 225),
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
      margin: const EdgeInsets.only(left: 12, right: 20, bottom: 10),
      width: screenWidth,
      child: child,
    );
  }
}
