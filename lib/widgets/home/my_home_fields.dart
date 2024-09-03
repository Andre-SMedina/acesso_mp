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
    double screenHeight = MediaQuery.of(context).size.height;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: widget.formKey,
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: screenHeight - 400,
                          maxWidth: 700,
                        ),
                        child: Consumer<XProvider>(
                          builder: (context, provider, child) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                provider.name,
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Flexible(child: provider.cpfWidget()),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(child: provider.rg),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(child: provider.phoneWidget()),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(child: provider.job),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    MyButton(
                                        callback: () {
                                          clearFields();
                                        },
                                        text: 'Limpar'),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    MyButton(
                                        callback: () {
                                          functions.update();
                                        },
                                        text: 'Atualizar'),
                                  ],
                                ),
                                const Divider(
                                  height: 150,
                                  thickness: 2,
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
                                        callback: () {},
                                        text: 'Registrar novo acesso'),
                                    MyButton(
                                        callback: () {
                                          ZshowDialogs.historic(
                                              context, widget.visitor);
                                        },
                                        text: 'Histórico'),
                                  ],
                                ),
                                const Spacer(flex: 10),
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                Column(
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
                    (widget.loadImage)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: StdValues.imgHeight2,
                              width: StdValues.imgWidth1,
                              child: Column(
                                children: [
                                  (widget.image == '')
                                      ? SizedBox(
                                          height: StdValues.imgHeight1,
                                          width: StdValues.imgWidth1,
                                          child: const Icon(
                                            Icons.person_outline_outlined,
                                            size: 200,
                                          ),
                                        )
                                      : SizedBox(
                                          height: StdValues.imgHeight1,
                                          width: StdValues.imgWidth1,
                                          child: Image.memory(
                                            base64Decode(widget.image),
                                            fit: BoxFit.cover,
                                          ),
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
                                  height: StdValues.imgHeight2,
                                  width: StdValues.imgWidth1,
                                  child: CameraApp(
                                    alert: widget.alertCamera,
                                    cameras: cameras,
                                  ),
                                ),
                              ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                const Spacer(
                  flex: 1,
                )
              ],
            ),
          ],
        ));
  }
}
