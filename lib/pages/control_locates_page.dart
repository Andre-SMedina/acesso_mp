import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/services/db_manage.dart';
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
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text('Controle de Lotações'),
            centerTitle: true,
            actions: [
              Row(
                children: [
                  const Text(
                    'Sair',
                    style: TextStyle(color: Colors.white),
                  ),
                  IconButton(
                      padding: const EdgeInsets.only(right: 30, left: 10),
                      onPressed: () async {
                        var supabase = Supabase.instance.client;
                        await supabase.auth.signOut();
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ))
                ],
              )
            ]),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/manut.jpg'),
                      fit: BoxFit.cover,
                      opacity: 0.1)),
              child: Padding(
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
                              width: 270,
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
                                        locateField,
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
                                            title: locations[index]['name'],
                                            hoverColor: const Color.fromARGB(
                                                255, 138, 199, 248),
                                            icon: Icons.location_city,
                                            callIcon: () {},
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
