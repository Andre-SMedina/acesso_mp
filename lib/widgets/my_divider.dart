import 'package:acesso_mp/helpers/std_values.dart';
import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: StdValues.dividerGrey,
      height: 20,
      thickness: 2,
    );
  }
}
