import 'package:flutter/material.dart';

class MyListTile extends StatefulWidget {
  final String title;
  final Color hoverColor;
  final IconData icon;
  final IconData? iconBtn;
  final Color? iconColor;
  final VoidCallback call;
  const MyListTile(
      {super.key,
      required this.title,
      required this.hoverColor,
      required this.icon,
      required this.call,
      this.iconBtn,
      this.iconColor});

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        widget.call();
      },
      leading: Icon(widget.icon),
      trailing: widget.iconBtn != null
          ? IconButton(
              onPressed: () {
                print('foibtn');
              },
              icon: Icon(
                widget.iconBtn,
                color: widget.iconColor,
              ),
            )
          : null,
      title: MouseRegion(
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
        child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: isHover ? const Color.fromARGB(255, 148, 198, 240) : null),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
