import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/services/db_manage.dart';
import 'package:acesso_mp/services/x_provider.dart';
import 'package:acesso_mp/widgets/form_operator.dart';
import 'package:acesso_mp/widgets/my_appbar.dart';
import 'package:acesso_mp/widgets/my_drawer.dart';
import 'package:acesso_mp/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    if (Supabase.instance.client.auth.currentUser == null) {
      return Scaffold(
        body: Center(
          child: SizedBox(
            height: 100,
            child: Column(
              children: [
                const Text(
                  'Nenhum usuário logado no sistema',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: const Text('Voltar para login'))
              ],
            ),
          ),
        ),
      );
    } else {
      var supabase = Supabase.instance.client;

      void updateProfile(Map data, int cpf) async {
        await supabase.from('operators').update(data).eq('cpf', cpf);
        setState(() {});
      }

      return Scaffold(
        drawer: const MyDrawer(),
        appBar: myAppbar(context, 'Controle de Operadores'),
        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Container(
              padding: const EdgeInsets.only(top: 50),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/manut.jpg'),
                      fit: BoxFit.cover,
                      opacity: 0.1)),
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Consumer(
                  builder: (context, provider, child) {
                    return Container(
                      constraints: const BoxConstraints(maxHeight: 550),
                      padding: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 3,
                          )),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: 470,
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
                              Padding(
                                padding: const EdgeInsets.only(top: 22.0),
                                child: formOperator,
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all()),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                        maxHeight: 400, maxWidth: 450),
                                    child: FutureBuilder(
                                      future: DbManage.getOperators(),
                                      builder: (context, snapshot) {
                                        var box = Hive.box('db');
                                        if (snapshot.hasData) {
                                          operators = snapshot.data!;
                                        }
                                        return ListView.builder(
                                            itemCount: operators.length,
                                            itemBuilder: (contex, index) {
                                              if (operators[index]['name'] ==
                                                  'adm') {
                                                return const Padding(
                                                    padding: EdgeInsets.zero);
                                              }
                                              return MyListTile(
                                                iconTip1:
                                                    'Usuário Administrador',
                                                iconTip2: 'Usuário Comum',
                                                title: operators[index]['name'],
                                                hoverColor:
                                                    const Color.fromARGB(
                                                        255, 138, 199, 248),
                                                iconBtn1: (operators[index]
                                                        ['adm'])
                                                    ? Icons.admin_panel_settings
                                                    : Icons
                                                        .person_outline_outlined,
                                                iconBtn2: operators[index]
                                                        ['active']
                                                    ? Icons.assignment_ind_sharp
                                                    : Icons
                                                        .do_not_disturb_alt_outlined,
                                                callMain: () {
                                                  box.put('operator',
                                                      operators[index]);
                                                  saveUpdate = false;
                                                  setState(() {});
                                                  contex
                                                      .read<XProvider>()
                                                      .loadOperatorField(
                                                          operators[index]);
                                                },
                                                actionBtn1: true,
                                                callIconBtn1: () {
                                                  updateProfile({
                                                    'adm': !operators[index]
                                                        ['adm']
                                                  }, operators[index]['cpf']);
                                                },
                                                callIconBtn2: () {
                                                  updateProfile({
                                                    'active': !operators[index]
                                                        ['active']
                                                  }, operators[index]['cpf']);
                                                },
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
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
