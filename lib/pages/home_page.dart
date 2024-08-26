// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/main.dart';
import 'package:acesso_mp/services/x_provider.dart';
import 'package:acesso_mp/widgets/my_appbar.dart';
import 'package:acesso_mp/widgets/my_drawer.dart';
import 'package:acesso_mp/models/model_visitors.dart';
import 'package:acesso_mp/services/database.dart';
import 'package:acesso_mp/services/data_manage.dart';
import 'package:acesso_mp/widgets/camera.dart';
import 'package:acesso_mp/widgets/my_dropdown.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  HomePage({super.key, required this.cameras});

  String image = '';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> visitor = [];

  bool loadImage = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> getDataVisitor() {
    var box = Hive.box('db');

    String img = (cameras.isEmpty && box.get('image') == '')
        ? 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII='
        : (box.get('image') == null)
            ? ''
            : box.get('image');

    return [
      context.read<XProvider>().name.fieldController.text,
      context
          .read<XProvider>()
          .cpfController
          .text
          .replaceAll(RegExp(r'\D'), ''),
      context.read<XProvider>().rg.fieldController.text,
      context
          .read<XProvider>()
          .phoneController
          .text
          .replaceAll(RegExp(r'\D'), ''),
      context.read<XProvider>().job.fieldController.text,
      img,
    ];
  }

  void loadData() {
    var box = Hive.box('db');
    var visitor = box.get('visitor');

    loadImage = true;
    widget.image = visitor['image'];
    box.put('image', visitor['image']);
    setState(() {});
    _formKey.currentState!.reset();
    context.read<XProvider>().loadVisitorsField(visitor);
  }

  void clearFields() {
    loadImage = true;
    widget.image = '';
    setState(() {});
    _formKey.currentState!.reset();
    context.read<XProvider>().clearFields();
  }

  alertCamera() {
    ZshowDialogs.alert(context, 'A aplicação apresentou erro');
  }

  alertAuth() {
    ZshowDialogs.alert(context, 'Autorização registrada!');
  }

  alertVisited() async {
    String visited = '';
    await ZshowDialogs.visited(context).then((v) => visited = v);

    return visited;
  }

  @override
  Widget build(BuildContext context) {
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
        appBar: myAppbar(context, 'Controle de Acesso ao Ministério Público'),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/mp.jpg'),
                fit: BoxFit.cover,
                opacity: 0.2),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<XProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: MyDropdown(
                          loadData: () {
                            loadData();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Informações do Visitante',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 26),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    provider.name,
                                    provider.cpfWidget(),
                                    provider.rg,
                                    provider.phoneWidget(),
                                    provider.job,
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                List dataVisitor =
                                                    getDataVisitor();

                                                if (dataVisitor[5] != '') {
                                                  final Database db = Database(
                                                      alertVisited:
                                                          alertVisited);

                                                  db
                                                      .register(
                                                          ModelVisitors(
                                                            name:
                                                                dataVisitor[0],
                                                            cpf: dataVisitor[1],
                                                            rg: dataVisitor[2],
                                                            phone:
                                                                dataVisitor[3],
                                                            job: dataVisitor[4],
                                                            image:
                                                                dataVisitor[5],
                                                          ),
                                                          'save')
                                                      .then((v) {
                                                    if (v == 'saved') {
                                                      ZshowDialogs.alert(
                                                          context,
                                                          'Cadastro realizado com sucesso!');
                                                      clearFields();
                                                    } else if (v == 'exist') {
                                                      ZshowDialogs.alert(
                                                          context,
                                                          'CPF já cadastrado!',
                                                          subTitle:
                                                              'Selecione "Limpar" para depois cadastrar.');
                                                    } else if (v ==
                                                        'cpfExist') {
                                                      ZshowDialogs.alert(
                                                          context,
                                                          'CPF já cadastrado!');
                                                    }
                                                  });
                                                } else {
                                                  ZshowDialogs.alert(context,
                                                      'Imagem não capturada!');
                                                }
                                              }
                                            },
                                            child: const Text('Cadastrar')),
                                        ElevatedButton(
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                bool validate = false;

                                                await ZshowDialogs.confirm(
                                                        context,
                                                        'Deseja atualizar os dados?')
                                                    .then((e) {
                                                  validate = e;
                                                });

                                                if (!validate) return;
                                                List dataVisitor =
                                                    getDataVisitor();
                                                if (dataVisitor[5] != '') {
                                                  final Database db = Database(
                                                      alertVisited:
                                                          alertVisited);

                                                  db
                                                      .register(
                                                          ModelVisitors(
                                                            name:
                                                                dataVisitor[0],
                                                            cpf: dataVisitor[1],
                                                            rg: dataVisitor[2],
                                                            phone:
                                                                dataVisitor[3],
                                                            job: dataVisitor[4],
                                                            image:
                                                                dataVisitor[5],
                                                          ),
                                                          'update')
                                                      .then((v) {
                                                    if (v == 'updated') {
                                                      ZshowDialogs.alert(
                                                          context,
                                                          'Registro atualizado!');
                                                    } else {
                                                      ZshowDialogs.alert(
                                                          context,
                                                          'Registro não encontrado!');
                                                    }
                                                  });
                                                } else {
                                                  ZshowDialogs.alert(context,
                                                      'Imagem não capturada!');
                                                }
                                              }
                                            },
                                            child: const Text('Atualizar')),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 254, 3, 3)),
                                          onPressed: () {
                                            clearFields();
                                          },
                                          child: const Text(
                                            'Limpar',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 10, 1, 194)),
                                            onPressed: () {
                                              ZshowDialogs.historic(
                                                  context, visitor);
                                            },
                                            child: const Text(
                                              'Histórico',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      height: 350,
                                      width: 320,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(width: 2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: (loadImage)
                                            ? Column(
                                                children: [
                                                  Expanded(
                                                    child: (widget.image == '')
                                                        ? const Icon(
                                                            Icons
                                                                .image_not_supported_outlined,
                                                            size: 200,
                                                          )
                                                        : Image.memory(
                                                            base64Decode(
                                                                widget.image),
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8.0),
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            loadImage = false;
                                                          });
                                                        },
                                                        child: const Text(
                                                            'Capturar')),
                                                  )
                                                ],
                                              )
                                            : (cameras.isEmpty)
                                                ? const Text(
                                                    'Câmera não encontrada!')
                                                : CameraApp(
                                                    cameras: cameras,
                                                    alert: alertCamera,
                                                  ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  ElevatedButton(
                                      onPressed: () async {
                                        ManageData manageDate = ManageData(
                                          alert: alertAuth,
                                          alertVisited: alertVisited,
                                        );

                                        bool success = false;
                                        await manageDate
                                            .authorized()
                                            .then((v) => success = v);

                                        if (success) {
                                          clearFields();
                                        }
                                      },
                                      child: const Text('Autorizar'))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    }
  }
}
