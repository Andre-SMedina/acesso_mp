import 'package:acesso_mp/helpers/std_values.dart';
import 'package:flutter/material.dart';

class MyHomeContainer extends StatelessWidget {
  final Widget child;
  final double? difHeight;
  const MyHomeContainer({super.key, required this.child, this.difHeight});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - 340;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
            color: Color.fromARGB(255, 178, 178, 178),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 5))
      ], color: StdValues.bkgGrey, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
      margin: const EdgeInsets.only(left: 12, right: 20),
      width: screenWidth,
      height: difHeight != null ? screenHeight - difHeight! : null,
      child: child,
    );
  }
}
