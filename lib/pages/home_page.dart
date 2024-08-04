// import 'dart:convert';
import 'dart:convert';

import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/main.dart';
import 'package:acesso_mp/widgets/home_fields.dart';
import 'package:acesso_mp/models/model_visitors.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/services/database.dart';
import 'package:acesso_mp/services/manage_data.dart';
import 'package:acesso_mp/widgets/camera.dart';
import 'package:acesso_mp/widgets/my_dropdown.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:validatorless/validatorless.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  HomePage({super.key, required this.cameras});

  ModelHomeFields nameField = ModelHomeFields(
    text: 'Nome',
    listInputFormat: const [],
    listValidator: [
      Validatorless.required('Campo obrigatório!'),
      (v) => v!.split(' ').length >= 2
          ? null
          : 'O nome deve ter nome e sobrenome!',
    ],
  );
  ModelHomeFields cpfField = ModelHomeFields(
    text: 'CPF',
    listValidator: [
      Validatorless.cpf('CPF inválido!'),
      Validatorless.required('Campo obrigatório!')
    ],
    listInputFormat: [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(11)
    ],
  );
  ModelHomeFields rgField = ModelHomeFields(
    text: 'RG',
    listInputFormat: [
      FilteringTextInputFormatter.digitsOnly,
    ],
    listValidator: [Validatorless.required('Campo obrigatório!')],
  );
  ModelHomeFields phoneField = ModelHomeFields(
    text: 'Telefone',
    listInputFormat: [
      FilteringTextInputFormatter.digitsOnly,
    ],
    listValidator: [Validatorless.required('Campo obrigatório!')],
  );
  ModelHomeFields jobField = ModelHomeFields(
    text: 'Profissão',
    listValidator: [Validatorless.required('Campo obrigatório!')],
    listInputFormat: const [],
  );
  String image = '';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> visitor = [];

  bool loadImage = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<List<String>> getDataVisitor() async {
    var box = Hive.box('db');

    String img = cameras.isEmpty
        ? 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII='
        : (box.get('image') == null)
            ? ''
            : box.get('image');

    return [
      widget.nameField.fieldController.text,
      widget.cpfField.fieldController.text,
      widget.rgField.fieldController.text,
      widget.phoneField.fieldController.text,
      widget.jobField.fieldController.text,
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
    widget.nameField.loadData(Convert.firstUpper(visitor['name']));
    widget.cpfField.loadData(visitor['cpf']);
    widget.rgField.loadData(visitor['rg']);
    widget.phoneField.loadData(visitor['phone']);
    widget.jobField.loadData(visitor['job']);
  }

  void clearFields() {
    var box = Hive.box('db');
    box.putAll({'visitor': '', 'image': ''});
    loadImage = true;
    widget.image = '';
    setState(() {});
    widget.nameField.clearData();
    widget.cpfField.clearData();
    widget.rgField.clearData();
    widget.phoneField.clearData();
    widget.jobField.clearData();
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Controle de Acesso ao Ministério Público'),
      ),
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
            child: Column(
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
                              widget.nameField,
                              widget.cpfField,
                              widget.rgField,
                              widget.phoneField,
                              widget.jobField,
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          getDataVisitor().then((e) {
                                            if (e[5] != '') {
                                              final Database db = Database(
                                                  alertVisited: alertVisited);

                                              db
                                                  .register(
                                                      ModelVisitors(
                                                        name: e[0],
                                                        cpf: e[1],
                                                        rg: e[2],
                                                        phone: e[3],
                                                        job: e[4],
                                                        image: e[5],
                                                      ),
                                                      'save')
                                                  .then((v) {
                                                if (v == 'saved') {
                                                  ZshowDialogs.alert(context,
                                                      'Cadastro realizado com sucesso!');
                                                  clearFields();
                                                } else if (v == 'exist') {
                                                  ZshowDialogs.alert(context,
                                                      'Pessoa já cadastrada!');
                                                } else if (v == 'empty') {
                                                  ZshowDialogs.alert(context,
                                                      'Quem visitar, não preenchido!');
                                                }
                                              });
                                            } else {
                                              ZshowDialogs.alert(context,
                                                  'Imagem não capturada!');
                                            }
                                          });
                                        }
                                      },
                                      child: const Text('Novo Cadastro')),
                                  ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          getDataVisitor().then((e) {
                                            if (e[5] != '') {
                                              final Database db = Database(
                                                  alertVisited: alertVisited);
                                              db
                                                  .register(
                                                      ModelVisitors(
                                                        name: e[0],
                                                        cpf: e[1],
                                                        rg: e[2],
                                                        phone: e[3],
                                                        job: e[4],
                                                        image: e[5],
                                                      ),
                                                      'update')
                                                  .then((v) {
                                                if (v == 'updated') {
                                                  ZshowDialogs.alert(context,
                                                      'Registro atualizado!');
                                                } else {
                                                  ZshowDialogs.alert(context,
                                                      'Registro não encontrado!');
                                                }
                                              });
                                            } else {
                                              ZshowDialogs.alert(context,
                                                  'Imagem não capturada!');
                                            }
                                          });
                                        }
                                      },
                                      child: const Text('Atualizar')),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 254, 3, 3)),
                                    onPressed: () {
                                      clearFields();
                                    },
                                    child: const Text(
                                      'Limpar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 10, 1, 194)),
                                      onPressed: () {
                                        ZshowDialogs.historic(context, visitor);
                                      },
                                      child: const Text(
                                        'Histórico',
                                        style: TextStyle(color: Colors.white),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      loadImage = false;
                                                    });
                                                  },
                                                  child:
                                                      const Text('Capturar')),
                                            )
                                          ],
                                        )
                                      : (cameras.isEmpty)
                                          ? const Text('Câmera não encontrada!')
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
            ),
          ),
        ),
      ),
    );
  }
}
