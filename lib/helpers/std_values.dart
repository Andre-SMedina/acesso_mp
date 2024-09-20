import 'package:flutter/material.dart';

class StdValues {
  static double Function(BuildContext) screenWidth =
      (BuildContext context) => MediaQuery.sizeOf(context).width;
  //Colors
  static Color bkgBlue = const Color(0xFF004A7C);
  static Color btnBlue = const Color(0xFF053F63);
  static Color bkgGrey = const Color(0xFFF2F2F2);
  static Color dividerGrey = const Color(0xFFB5B5B5);
  static Color hoverGreyBtn = const Color(0xFFB4B4B4);
  static Color hoverGreyIcon = const Color(0xFFE0E0E0);
  static Color bkgFieldGrey = const Color(0xFFF5F5F5);
  static Color borderFieldGrey = const Color.fromARGB(255, 105, 105, 105);
  static Color labelGrey = const Color.fromARGB(255, 105, 105, 105);
  static Color textGrey = const Color(0xFF7D7D7D);
  static Color shadowGrey = const Color.fromARGB(255, 178, 178, 178);
  //Sizes
  static double imgHeight1 = 350;
  static double imgHeight2 = 410;
  static double imgWidth1 = 350;
  static double imgWidth2 = 410;
  static TextStyle title =
      TextStyle(color: bkgBlue, fontSize: 20, fontWeight: FontWeight.bold);
  static TextStyle titleBox =
      TextStyle(color: Colors.white, fontSize: 18, backgroundColor: bkgBlue);
  static BoxDecoration boxShadow = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            color: shadowGrey,
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 5))
      ]);
  static BoxDecoration boxBar =
      BoxDecoration(color: bkgBlue, borderRadius: BorderRadius.circular(5));
}
