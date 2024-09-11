import 'dart:convert';

import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/main.dart';
import 'package:acesso_mp/services/db_visits.dart';
import 'package:acesso_mp/services/x_provider.dart';
import 'package:acesso_mp/widgets/home/camera.dart';
import 'package:acesso_mp/widgets/home/image_border.dart';
import 'package:acesso_mp/widgets/home/my_home_container.dart';
import 'package:acesso_mp/widgets/home/my_home_functions.dart';
import 'package:acesso_mp/widgets/my_button.dart';
import 'package:acesso_mp/widgets/my_divider.dart';
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

  alertAuth() {
    ZshowDialogs.alert(context, 'Autorização registrada!');
  }

  alertVisited() async {
    List<String> visited = [];
    await ZshowDialogs.visited(widget.context).then((v) => visited = v);

    return visited;
  }

  void clearFields() {
    widget.image = '';
    setState(() {
      widget.loadImage = true;
    });
    widget.formKey.currentState!.reset();
    widget.context.read<XProvider>().clearFields();
  }

  void reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool admUser() {
      if (MyFunctons.getHive('profile')['name'] == 'adm') {
        ZshowDialogs.alert(context, 'Ação bloqueada para esse usuário!');
        return true;
      } else {
        return false;
      }
    }

    bool sizeValidate =
        (MediaQuery.sizeOf(context).width <= 1700) ? false : true;

    var functions = MyHomeFunctions(
        clearFields: clearFields,
        formKey: widget.formKey,
        getDataVisitor: getDataVisitor,
        context: context,
        alertVisited: alertVisited);

    Widget authButton = MyButton(
        icon: Icons.door_back_door_outlined,
        callback: () async {
          if (admUser()) return;

          DbVisits manageDate = DbVisits(
            alert: alertAuth,
            alertVisited: alertVisited,
          );

          bool success = false;
          await manageDate.authorized(context).then((v) => success = v);

          if (success) {
            clearFields();
          }
        },
        text: 'Registrar novo Acesso');

    return MyHomeContainer(
        difHeight: 317,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('INFORMAÇÕES DO VISITANTE',
                  style: TextStyle(
                      color: StdValues.bkgBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const MyDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 6,
                    child: Form(
                      key: widget.formKey,
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 550,
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
                                    Divider(
                                      height: sizeValidate ? 150 : 30,
                                      thickness: 2,
                                    ),
                                    const Spacer(flex: 1),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const SizedBox(
                                          width: 35,
                                        ),
                                        MyButton(
                                            icon: Icons.cloud_upload_outlined,
                                            callback: () {
                                              if (admUser()) return;
                                              functions.register();
                                            },
                                            text: 'Cadastrar Visitante'),
                                        (sizeValidate)
                                            ? authButton
                                            : const SizedBox(),
                                        MyButton(
                                            icon: Icons.access_time_outlined,
                                            callback: () {
                                              ZshowDialogs.historic(
                                                  context, widget.visitor);
                                            },
                                            text: 'Histórico'),
                                        const SizedBox(
                                          width: 35,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    sizeValidate
                                        ? const SizedBox()
                                        : SizedBox(
                                            width: 250, child: authButton),
                                    const Spacer(flex: 10),
                                  ],
                                );
                              },
                            ),
                          )
                        ],
                      ),
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
                                        ? ImageBorder(
                                            height: StdValues.imgHeight1,
                                            width: StdValues.imgWidth1,
                                            widget: Container(
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/cam.png'),
                                              )),
                                            ),
                                          )
                                        : ImageBorder(
                                            height: StdValues.imgHeight1,
                                            width: StdValues.imgWidth1,
                                            widget: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                              child: Image.memory(
                                                base64Decode(widget.image),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      width: 190,
                                      child: MyButton(
                                          icon: Icons.camera_alt_outlined,
                                          callback: () {
                                            setState(() {
                                              widget.loadImage = false;
                                            });
                                          },
                                          text: 'Registrar Foto'),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : (widget.cameras.isEmpty)
                              ? ImageBorder(
                                  height: StdValues.imgHeight1,
                                  width: StdValues.imgWidth1,
                                  widget: const Center(
                                      child: Text('Câmera não encontrada!',
                                          style: TextStyle(fontSize: 20))))
                              : SizedBox(
                                  height: StdValues.imgHeight2,
                                  width: StdValues.imgWidth1,
                                  child: CameraApp(
                                    alert: widget.alertCamera,
                                    cameras: cameras,
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
          ),
        ));
  }
}
