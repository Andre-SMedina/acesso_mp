import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/models/model_visitors.dart';
import 'package:acesso_mp/services/database.dart';
import 'package:acesso_mp/services/x_provider.dart';
import 'package:acesso_mp/widgets/home/my_home_container.dart';
import 'package:acesso_mp/widgets/my_button.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyHomeFields extends StatelessWidget {
  final BuildContext context;
  bool loadImage;
  String image;
  final GlobalKey<FormState> formKey;
  final void Function() reload;
  final List<CameraDescription> cameras;
  MyHomeFields({
    super.key,
    required this.context,
    required this.loadImage,
    required this.image,
    required this.cameras,
    required this.reload,
    required this.formKey,
  });

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

  alertVisited() async {
    List<String> visited = [];
    await ZshowDialogs.visited(context).then((v) => visited = v);

    return visited;
  }

  void clearFields() {
    loadImage = true;
    image = '';
    reload();
    formKey.currentState!.reset();
    context.read<XProvider>().clearFields();
  }

  @override
  Widget build(BuildContext context) {
    return MyHomeContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('INFORMAÇÕES DO VISITANTE',
            style: TextStyle(
                color: Color(0xFF053F63),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        const Divider(
          color: Color.fromARGB(255, 172, 172, 172),
          height: 20,
          thickness: 2,
        ),
        Row(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: 621,
                    child: Consumer<XProvider>(
                      builder: (context, provider, child) {
                        return Column(
                          children: [
                            provider.name,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: 300, child: provider.cpfWidget()),
                                SizedBox(width: 300, child: provider.rg),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 300, child: provider.job),
                                SizedBox(
                                    width: 300, child: provider.phoneWidget()),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MyButton(
                                    callback: () {
                                      if (formKey.currentState!.validate()) {
                                        List dataVisitor = getDataVisitor();

                                        if (dataVisitor[5] != '') {
                                          final Database db = Database(
                                              alertVisited: alertVisited);

                                          db
                                              .register(
                                                  ModelVisitors(
                                                    name: dataVisitor[0],
                                                    cpf: dataVisitor[1],
                                                    rg: dataVisitor[2],
                                                    phone: dataVisitor[3],
                                                    job: dataVisitor[4],
                                                    image: dataVisitor[5],
                                                  ),
                                                  'save')
                                              .then((v) {
                                            if (v == 'saved') {
                                              ZshowDialogs.alert(context,
                                                  'Cadastro realizado com sucesso!');
                                              clearFields();
                                            } else if (v == 'exist') {
                                              ZshowDialogs.alert(
                                                  context, 'CPF já cadastrado!',
                                                  subTitle:
                                                      'Selecione "Limpar" para depois cadastrar.');
                                            } else if (v == 'cpfExist') {
                                              ZshowDialogs.alert(context,
                                                  'CPF já cadastrado!');
                                            }
                                          });
                                        } else {
                                          ZshowDialogs.alert(
                                              context, 'Imagem não capturada!');
                                        }
                                      }
                                    },
                                    text: 'Cadastrar'),
                                MyButton(callback: () {}, text: 'Limpar'),
                                MyButton(callback: () {}, text: 'Atualizar'),
                                MyButton(callback: () {}, text: 'Histórico'),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            MyButton(
                                callback: () {}, text: 'Registrar novo acesso'),
                            const SizedBox(
                              height: 10,
                            ),
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
                      fontSize: 19, color: Color.fromARGB(255, 105, 105, 105)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 2,
                            spreadRadius: 2,
                            offset: Offset(0, 3),
                            color: Colors.grey)
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                MyButton(callback: () {}, text: 'Tirar Foto'),
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
