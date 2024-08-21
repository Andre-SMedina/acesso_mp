import 'package:acesso_mp/services/db_manage.dart';
import 'package:acesso_mp/services/x_provider.dart';
import 'package:acesso_mp/widgets/form_operator.dart';
import 'package:acesso_mp/widgets/my_drawer.dart';
import 'package:acesso_mp/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class ControlOperatorsPage extends StatefulWidget {
  const ControlOperatorsPage({super.key});

  @override
  State<ControlOperatorsPage> createState() => _ControlOperatorsPageState();
}

class _ControlOperatorsPageState extends State<ControlOperatorsPage> {
  TextStyle title = const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

  bool saveUpdate = true;

  @override
  Widget build(BuildContext context) {
    FormOperator formOperator = FormOperator(
      callback: () {
        saveUpdate = true;
        setState(() {});
      },
    );
    var operators = [];
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Controle de Operadores'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/manut.jpg'),
                fit: BoxFit.cover,
                opacity: 0.1)),
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Consumer(
            builder: (context, value, child) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 270,
                            child: Text(
                              (saveUpdate)
                                  ? 'Cadastrar operador'
                                  : 'Editar operador',
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
                      formOperator,
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white, border: Border.all()),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                                maxHeight: 400, maxWidth: 400),
                            child: FutureBuilder(
                              future: DbManage.getOperators(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  operators = snapshot.data!;
                                }
                                return ListView.builder(
                                    itemCount: operators.length,
                                    itemBuilder: (contex, index) {
                                      return MyListTile(
                                        title: operators[index]['name'],
                                        hoverColor: const Color.fromARGB(
                                            255, 138, 199, 248),
                                        icon: Icons.person,
                                        //TODO: desativar operador
                                        iconBtn: operators[index] ==
                                                'João Paulo Fernandes'
                                            ? Icons.do_not_disturb_alt_outlined
                                            : Icons.assignment_ind_sharp,
                                        iconColor: const Color.fromARGB(
                                            255, 18, 0, 153),
                                        callMain: () {
                                          var box = Hive.box('db');
                                          box.put('operator', operators[index]);
                                          saveUpdate = false;
                                          setState(() {});
                                          contex
                                              .read<XProvider>()
                                              .loadOperatorField(
                                                  operators[index]);
                                        },
                                        callIcon: () {},
                                      );
                                    });
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
