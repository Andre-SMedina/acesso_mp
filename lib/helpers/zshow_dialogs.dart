import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:acesso_mp/services/db_manage.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

class ZshowDialogs {
  static Future<void> historic(
      BuildContext context, List<String> visitor) async {
    var checked = MyFunctons.getHive('visitor');
    List locations = [];
    await MyFunctons.getLocations().then((e) {
      locations = e;
    });

    if (checked != null && checked != '') {
      var visitorHistoric = checked['visits'];

      await showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text('Histórico de acessos')),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap:
                      true, // Permite que a lista ocupe o espaço mínimo necessário
                  itemCount:
                      visitorHistoric.length, // Número de elementos na lista
                  itemBuilder: (context, index) {
                    String operator = '';
                    String location = '';
                    List operators = MyFunctons.getHive('operators');

                    for (var i in locations) {
                      if (i['id'] == visitorHistoric[index]['id_location']) {
                        location = i['name'];
                      }
                    }

                    for (var i = 0; i < operators.length; i++) {
                      if (operators[i]['id'] ==
                          visitorHistoric[index]['id_operator']) {
                        operator = operators[i]['name'];
                      }
                    }

                    TextSpan myText(String text) {
                      return TextSpan(
                          text: '$text: ',
                          style: const TextStyle(fontWeight: FontWeight.bold));
                    }

                    return Column(
                      children: [
                        ListTile(
                          leading:
                              const Icon(Icons.check_circle_outline_outlined),
                          title: RichText(
                            text: TextSpan(
                              children: [
                                myText('Operador'),
                                TextSpan(text: operator),
                                myText('\nLocal'),
                                TextSpan(text: location),
                                myText('\nData'),
                                TextSpan(text: visitorHistoric[index]['date']),
                                myText('\nFinalidade '),
                                TextSpan(text: visitorHistoric[index]['goal']),
                                myText('\nAutorizado por '),
                                TextSpan(
                                    text: visitorHistoric[index]
                                        ['authorizedBy']),
                              ],
                            ),
                          ),
                        ),
                        if (index < visitorHistoric.length - 1) const Divider()
                      ],
                    );
                  },
                ),
              ),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }

  static Future<void> alert(BuildContext context, String titleMsg,
      {String subTitle = ''}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            titleMsg,
            textAlign: TextAlign.center,
          ),
          content: (subTitle != '')
              ? Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          actions: [
            Center(
              child: ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<List<String>> visited(BuildContext context) async {
    late TextEditingController textController1 = TextEditingController();
    late TextEditingController textController2 = TextEditingController();
    FocusNode focusNode = FocusNode();
    String goalText = '';
    String whoAuth = '';

    void focusDispose() {
      focusNode.dispose();
    }

    await showDialog(
      context: context,
      builder: (context) {
        focusNode.requestFocus();
        return AlertDialog(
          title: const Text('Informações sobre o acesso.'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 140),
            child: Column(
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Finalidade'),
                    focusNode: focusNode,
                    controller: textController1,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: textController2,
                    onSubmitted: (v) {
                      if (textController1.text != '') {
                        focusDispose();
                        whoAuth = textController2.text;
                        goalText = textController1.text;
                        Navigator.of(context).pop();
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Quem autorizou',
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  if (textController1.text != '') {
                    focusDispose();
                    goalText = textController1.text;
                    whoAuth = textController2.text;
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        );
      },
    );

    return [goalText, whoAuth];
  }

  static Future<bool> confirm(BuildContext context, String title) async {
    bool validate = false;

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      validate = true;
                      Navigator.pop(context);
                    },
                    child: const Text('Sim')),
                const SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Não'))
              ],
            ),
          );
        });

    return validate;
  }

  static Future<bool> updateLocate(BuildContext context, String oldName) async {
    bool validate = false;

    TextEditingController fieldController =
        TextEditingController(text: oldName);
    FocusNode focusNode = FocusNode();
    focusNode.requestFocus();

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Alterar lotação',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 130,
              width: 400,
              child: Column(
                children: [
                  TextFormField(
                    validator: Validatorless.multiple(
                        [Validatorless.required('Campo obrgatório!')]),
                    controller: fieldController,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Novo nome',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (fieldController.text.isNotEmpty) {
                          await DbManage.update(
                              column: 'name',
                              data: {'name': fieldController.text},
                              table: 'locations',
                              find: oldName,
                              boxName: '');
                          validate = true;
                        }

                        focusNode.dispose();

                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: const Text('Salvar alteração')),
                ],
              ),
            ),
          );
        });

    return validate;
  }

  static Future<List> updatePassword(BuildContext context) async {
    bool validate = false;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController passwordController = TextEditingController();
    var validates = [
      Validatorless.required('Campo Obrigatório'),
      Validatorless.min(6, 'A senha não pode ter menos de 6 caracteres!'),
    ];

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Atualizar senha',
              textAlign: TextAlign.center,
            ),
            content: Form(
              key: formKey,
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 200, minWidth: 300),
                child: Column(
                  children: [
                    TextFormField(
                      validator: Validatorless.multiple(
                        validates,
                      ),
                      controller: passwordController,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Senha',
                          helperText: ''),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: Validatorless.multiple([
                        ...validates,
                        Validatorless.compare(
                            passwordController, 'As senhas não são iguais!')
                      ]),
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Confirmar senha',
                          helperText: ''),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            validate = true;
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Registrar'))
                  ],
                ),
              ),
            ),
          );
        });

    return [validate, passwordController.text];
  }
}
