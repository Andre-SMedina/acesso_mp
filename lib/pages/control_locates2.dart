import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/widgets/home/my_home_container.dart';
import 'package:flutter/material.dart';

class ControlLocates2 extends StatelessWidget {
  const ControlLocates2({super.key});

  @override
  Widget build(BuildContext context) {
    return MyHomeContainer(
        child: Column(
      children: [
        const Text('CONTROLE DE LOTAÇÕES'),
        Divider(
          color: StdValues.dividerGrey,
        )
      ],
    ));
  }
}
