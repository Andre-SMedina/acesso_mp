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
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(10)),
          height: height,
          width: width,
          child: widget),
    );
  }
}
