import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/widgets/home/my_home_container.dart';
import 'package:acesso_mp/widgets/home/my_home_formfield.dart';
import 'package:acesso_mp/widgets/my_button.dart';
import 'package:acesso_mp/widgets/my_divider.dart';
import 'package:flutter/material.dart';

class HistoryPage2 extends StatelessWidget {
  const HistoryPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return MyHomeContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('HISTÓRICO DE VISITAS',
            style: TextStyle(
                color: StdValues.bkgBlue,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        const MyDivider(),
        const SizedBox(
          height: 40,
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: MyHomeFormfield(
                  labelTitle: 'Visitas de Hoje', listValidator: const []),
            ),
            const SizedBox(
              width: 50,
            ),
            Flexible(
                flex: 1,
                child: MyHomeFormfield(
                    icon: Icon(
                      Icons.calendar_month,
                      color: StdValues.labelGrey,
                    ),
                    labelTitle: 'Data',
                    labelText: 'Selecione uma Data',
                    listValidator: const [])),
            const SizedBox(
              width: 50,
            ),
            Flexible(flex: 1, child: MyButton(callback: () {}, text: 'Buscar'))
          ],
        )
      ],
    ));
  }
}
