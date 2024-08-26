import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/services/db_manage.dart';
import 'package:acesso_mp/widgets/my_appbar.dart';
import 'package:acesso_mp/widgets/my_drawer.dart';
import 'package:acesso_mp/widgets/my_list_tile.dart';
import 'package:acesso_mp/widgets/my_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:validatorless/validatorless.dart';

class ControlLocatesPage extends StatefulWidget {
  const ControlLocatesPage({super.key});

  @override
  State<ControlLocatesPage> createState() => _ControlLocatesPageState();
}

class _ControlLocatesPageState extends State<ControlLocatesPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  MyTextField locate = MyTextField(
      text: 'Lotação',
      listValidator: [Validatorless.required('Campo obrigatório')],
      listInputFormat: const []);

  @override
  Widget build(BuildContext context) {
    var locations = [];
    TextStyle title =
        const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
    MyTextField locateField = MyTextField(
        text: 'Lotação',
        listValidator: [Validatorless.required('Campo obrgatório!')],
        listInputFormat: const []);
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
      return Scaffold(
        drawer: const MyDrawer(),
        appBar: myAppbar(context, 'Controle de Lotações'),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/manut.jpg'),
                      fit: BoxFit.cover,
                      opacity: 0.1)),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 540),
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
                          Container(
                              padding: const EdgeInsets.only(left: 60),
                              width: 470,
                              child: Text(
                                'Cadastrar lotação',
                                style: title,
                              )),
                          Text(
                            'Lista de lotações',
                            style: title,
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                            key: formKey,
                            child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                    maxHeight: 400, maxWidth: 400),
                                child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            width: 350, child: locateField),
                                        ElevatedButton(
                                            onPressed: () async {
                                              bool validate = false;

                                              if (formKey.currentState!
                                                  .validate()) {
                                                await DbManage.saveLocate(
                                                        locateField
                                                            .fieldController
                                                            .text)
                                                    .then((e) => validate = e);
                                                if (!validate) {
                                                  // ignore: use_build_context_synchronously
                                                  return ZshowDialogs.alert(
                                                      // ignore: use_build_context_synchronously
                                                      context,
                                                      'Lotação já cadastrada!');
                                                }
                                                setState(() {});
                                                // ignore: use_build_context_synchronously
                                                ZshowDialogs.alert(context,
                                                    'Cadastro realizado com sucesso!');
                                              }
                                            },
                                            child: const Text('Cadastrar'))
                                      ],
                                    )))),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white, border: Border.all()),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                    maxHeight: 400, maxWidth: 300),
                                child: FutureBuilder(
                                  future: DbManage.getLocations(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      locations = snapshot.data;
                                    }
                                    return ListView.builder(
                                        itemCount: locations.length,
                                        itemBuilder: (contex, index) {
                                          return MyListTile(
                                            iconTip1: '',
                                            iconTip2: '',
                                            title: locations[index]['name'],
                                            hoverColor: const Color.fromARGB(
                                                255, 138, 199, 248),
                                            iconBtn1: Icons.location_city,
                                            actionBtn1: false,
                                            callIconBtn1: () {},
                                            callIconBtn2: () {},
                                            callMain: () async {
                                              await ZshowDialogs.updateLocate(
                                                      contex,
                                                      locations[index]['name'])
                                                  .then((v) {
                                                if (v) {
                                                  setState(() {});
                                                }
                                              });
                                            },
                                          );
                                        });
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
