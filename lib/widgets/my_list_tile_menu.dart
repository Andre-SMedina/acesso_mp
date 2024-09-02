import 'package:flutter/material.dart';

class MyListTile2 extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool? actionBtn1;
  final Function? callMain;
  final int index;
  final int selectedIndex;
  final Function(int) onSelect;
  const MyListTile2(
      {super.key,
      required this.title,
      this.callMain,
      this.actionBtn1 = true,
      required this.icon,
      required this.index,
      required this.selectedIndex,
      required this.onSelect});

  @override
  State<MyListTile2> createState() => _MyListTile2State();
}

class _MyListTile2State extends State<MyListTile2> {
  bool isHover = false;
  Color? colorSelect;

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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: (widget.selectedIndex == widget.index)
              ? const Color(0xFF053F63)
              : (isHover)
                  ? const Color.fromARGB(255, 152, 152, 152)
                  : colorSelect,
        ),
        child: ListTile(
          onTap: () {
            widget.onSelect(widget.index);
            if (widget.callMain != null) {
              widget.callMain!();
            }
          },
          leading: AnimatedScale(
            duration: const Duration(milliseconds: 150),
            scale: isHover ? 1.2 : 1,
            child: Icon(
              widget.icon,
              color: (widget.selectedIndex == widget.index)
                  ? Colors.white
                  : (isHover)
                      ? Colors.white
                      : null,
              size: 35,
            ),
          ),
          title: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: TextStyle(
              color: (widget.selectedIndex == widget.index)
                  ? Colors.white
                  : (isHover)
                      ? Colors.white
                      : null,
              fontSize: 18,
            ),
            child: Text(widget.title),
          ),
        ),
      ),
    );
  }
}
