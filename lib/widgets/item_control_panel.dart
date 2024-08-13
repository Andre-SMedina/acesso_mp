import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class ItemControlPanel extends StatelessWidget {
  final String operator;
  final String sector;
  const ItemControlPanel(
      {super.key, required this.operator, required this.sector});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, left: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
              width: 260,
              child: TextButton(
                  onPressed: () {},
                  child: Align(
                      alignment: Alignment.centerLeft, child: Text(operator)))),
          Text(sector),
        ],
      ),
    );
  }
}
