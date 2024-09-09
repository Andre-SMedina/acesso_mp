import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/widgets/home/my_home_container.dart';
import 'package:acesso_mp/widgets/my_divider.dart';
import 'package:flutter/material.dart';

class ControlLocates2 extends StatelessWidget {
  const ControlLocates2({super.key});

  @override
  Widget build(BuildContext context) {
    return MyHomeContainer(
        difHeight: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CONTROLE DE LOTAÇÕES',
              style: StdValues.title,
            ),
            const MyDivider()
          ],
        ));
  }
}
