import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/widgets/home/my_home_container.dart';
import 'package:flutter/material.dart';

class ControlOperators2 extends StatelessWidget {
  const ControlOperators2({super.key});

  @override
  Widget build(BuildContext context) {
    return MyHomeContainer(
        child: Column(
      children: [
        const Text('CONTROLE DE OPERADORES'),
        Divider(
          color: StdValues.dividerGrey,
        )
      ],
    ));
  }
}
