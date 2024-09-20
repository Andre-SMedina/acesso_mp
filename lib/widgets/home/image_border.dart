import 'package:acesso_mp/helpers/std_values.dart';
import 'package:flutter/material.dart';

class ImageBorder extends StatelessWidget {
  final double height;
  final double width;
  final Widget widget;
  const ImageBorder(
      {super.key,
      required this.height,
      required this.width,
      required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0.5),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2, color: StdValues.borderFieldGrey),
          borderRadius: BorderRadius.circular(40)),
      height: height,
      width: width,
      child: widget,
    );
  }
}
