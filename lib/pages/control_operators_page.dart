import 'package:acesso_mp/widgets/form_operator.dart';
import 'package:acesso_mp/widgets/my_drawer.dart';
import 'package:acesso_mp/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ControlOperatorsPage extends StatefulWidget {
  const ControlOperatorsPage({super.key});

  @override
  State<ControlOperatorsPage> createState() => _ControlOperatorsPageState();
}

class _ControlOperatorsPageState extends State<ControlOperatorsPage> {
  List list = [
    'Maria Eduarda',
    'José da Silva Barbosa',
    'Carlos Eduardo Costa',
    'João Paulo Fernandes',
    'Pedro Júnior Soares',
    'Juliana Mendes Mota',
    'Maria Eduarda',
    'José da Silva Barbosa',
    'Carlos Eduardo Costa',
    'Pedro Júnior Soares',
    'Juliana Mendes Mota',
    'Maria Eduarda',
    'José da Silva Barbosa',
    'Carlos Eduardo Costa',
    'Pedro Júnior Soares',
    'Juliana Mendes Mota'
  ];

  TextStyle title = const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Controle de Operadores'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 230,
                      child: Text(
                        'Cadastrar operador',
                        style: title,
                      )),
                  Text(
                    'Lista de operadores',
                    style: title,
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FormOperator(),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxHeight: 400, maxWidth: 400),
                      child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (contex, index) {
                            return MyListTile(
                                title: list[index],
                                hoverColor: Colors.blue,
                                icon: Icons.person,
                                iconBtn: list[index] == 'João Paulo Fernandes'
                                    ? Icons.do_not_disturb_alt_outlined
                                    : Icons.assignment_ind_sharp,
                                page: () {});
                          }),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
