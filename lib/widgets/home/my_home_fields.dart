import 'dart:convert';

import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/main.dart';
import 'package:acesso_mp/services/x_provider.dart';
import 'package:acesso_mp/widgets/camera.dart';
import 'package:acesso_mp/widgets/home/my_home_container.dart';
import 'package:acesso_mp/widgets/home/my_home_functions.dart';
import 'package:acesso_mp/widgets/my_button.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyHomeFields extends StatefulWidget {
  final BuildContext context;
  bool loadImage;
  String image;
  final List<String> visitor;
  final GlobalKey<FormState> formKey;
  final void Function() alertCamera;
  final List<CameraDescription> cameras;
  MyHomeFields({
    super.key,
    required this.context,
    required this.loadImage,
    required this.image,
    required this.cameras,
    required this.formKey,
    required this.visitor,
    required this.alertCamera,
  });

  @override
  State<MyHomeFields> createState() => _MyHomeFieldsState();
}

class _MyHomeFieldsState extends State<MyHomeFields> {
  List<String> getDataVisitor() {
    var box = Hive.box('db');

    String img = (widget.cameras.isEmpty && box.get('image') == '')
        ? 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII='
        : (box.get('image') == null)
            ? ''
            : box.get('image');

    return [
      widget.context.read<XProvider>().name.fieldController.text,
      widget.context
          .read<XProvider>()
          .cpfController
          .text
          .replaceAll(RegExp(r'\D'), ''),
      widget.context.read<XProvider>().rg.fieldController.text,
      widget.context
          .read<XProvider>()
          .phoneController
          .text
          .replaceAll(RegExp(r'\D'), ''),
      widget.context.read<XProvider>().job.fieldController.text,
      img,
    ];
  }

  alertVisited() async {
    List<String> visited = [];
    await ZshowDialogs.visited(widget.context).then((v) => visited = v);

    return visited;
  }

  void clearFields() {
    widget.loadImage = true;
    widget.image = '';
    setState(() {});
    widget.formKey.currentState!.reset();
    widget.context.read<XProvider>().clearFields();
  }

  void reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final CameraApp camera = CameraApp(
      cameras: widget.cameras,
      alert: widget.alertCamera,
    );
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var functions = MyHomeFunctions(
        clearFields: clearFields,
        formKey: widget.formKey,
        getDataVisitor: getDataVisitor,
        context: context,
        alertVisited: alertVisited);

    return MyHomeContainer(
        difHeight: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('INFORMAÇÕES DO VISITANTE',
                style: TextStyle(
                    color: StdValues.bkgBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Divider(
              color: StdValues.dividerGrey,
              height: 20,
              thickness: 2,
            ),
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  Form(
                    key: widget.formKey,
                    child: Column(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: screenHeight - 400,
                            maxWidth: screenWidth - 900,
                          ),
                          child: Consumer<XProvider>(
                            builder: (context, provider, child) {
                              return Column(
                                children: [
                                  const Spacer(flex: 1),
                                  provider.name,
                                  const Spacer(flex: 1),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                          width: 300,
                                          child: provider.cpfWidget()),
                                      SizedBox(width: 300, child: provider.rg),
                                    ],
                                  ),
                                  const Spacer(flex: 1),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 300, child: provider.job),
                                      SizedBox(
                                          width: 300,
                                          child: provider.phoneWidget()),
                                    ],
                                  ),
                                  const Spacer(flex: 1),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      MyButton(
                                          callback: () {
                                            functions.register();
                                          },
                                          text: 'Cadastrar'),
                                      MyButton(
                                          callback: () {
                                            clearFields();
                                          },
                                          text: 'Limpar'),
                                      MyButton(
                                          callback: () {
                                            functions.update();
                                          },
                                          text: 'Atualizar'),
                                      MyButton(
                                          callback: () {
                                            ZshowDialogs.historic(
                                                context, widget.visitor);
                                          },
                                          text: 'Histórico'),
                                    ],
                                  ),
                                  const Spacer(flex: 1),
                                  MyButton(
                                      callback: () {},
                                      text: 'Registrar novo acesso'),
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                  Flexible(
                    flex: 5,
                    child: Column(
                      children: [
                        const Text(
                          'Foto de Identificação',
                          style: TextStyle(
                              fontSize: 19,
                              color: Color.fromARGB(255, 105, 105, 105)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: (widget.loadImage)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    height: 250,
                                    width: 300,
                                    child: Column(
                                      children: [
                                        (widget.image == '')
                                            ? const Icon(
                                                Icons.person_outline_outlined,
                                                size: 200,
                                              )
                                            : Image.memory(
                                                base64Decode(widget.image),
                                                fit: BoxFit.cover,
                                              ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: MyButton(
                                              callback: () {
                                                setState(() {
                                                  widget.loadImage = false;
                                                });
                                              },
                                              text: 'Alterar Foto'),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : (widget.cameras.isEmpty)
                                  ? const Text('Câmera não encontrada!')
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                        height: 300,
                                        width: 300,
                                        child: CameraApp(
                                          alert: widget.alertCamera,
                                          cameras: cameras,
                                        ),
                                      ),
                                    ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
