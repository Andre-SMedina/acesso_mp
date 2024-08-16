import 'package:flutter/material.dart';

class MyListTile extends StatefulWidget {
  final String title;
  final Color hoverColor;
  const MyListTile({
    super.key,
    required this.title,
    required this.hoverColor,
  });

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        cursor: SystemMouseCursors.click,
        child: ListTile(
          title: Text(widget.title),
          hoverColor: isHover ? widget.hoverColor : Colors.transparent,
        ));
  }
}
