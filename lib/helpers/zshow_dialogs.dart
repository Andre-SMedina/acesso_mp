import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/services/db_manage.dart';
import 'package:acesso_mp/widgets/home/my_formfield.dart';
import 'package:acesso_mp/widgets/my_button.dart';
import 'package:acesso_mp/widgets/my_dropdown.dart';
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
      List operators = MyFunctons.getHive('operators');

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
                                myText('Atendente'),
                                TextSpan(text: operator),
                                myText('\nCidade'),
                                TextSpan(text: location),
                                myText('\nData'),
                                TextSpan(
                                    text: Convert.formatDate(
                                        visitorHistoric[index]['date'])),
                                myText('\nHora'),
                                TextSpan(text: visitorHistoric[index]['time']),
                                myText('\nFinalidade '),
                                TextSpan(text: visitorHistoric[index]['goal']),
                                myText('\nLocal '),
                                TextSpan(
                                    text: visitorHistoric[index]['sector']),
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
                child: MyButton(
                  text: 'OK',
                  callback: () {
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
              child: SizedBox(
                width: 100,
                child: MyButton(
                  text: 'OK',
                  callback: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<List<String>> visited(BuildContext context) async {
    FocusNode focusNode = FocusNode();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String sectorSelected = '';
    String whoAuthSelected = '';
    TextEditingController locateController = TextEditingController();
    TextEditingController whoController = TextEditingController();

    void submit() {
      if (formKey.currentState!.validate() &&
          sectorSelected.isNotEmpty &&
          whoAuthSelected.isNotEmpty) {
        Navigator.of(context).pop();
      } else {
        ZshowDialogs.alert(context, 'Preencha todos os campos!');
      }
    }

    MyFormfield goal = MyFormfield(
        focusNode: focusNode,
        labelTitle: 'Finalidade',
        listValidator: [Validatorless.required('Campo obrigatório!')]);
    MyDropdown local = MyDropdown(
      searchController: locateController,
      labelText: 'Digite o nome do setor',
      optionsList: const [
        'ACEMA',
        'RTSI',
        'DMTI',
        'COMUN',
        '2prm',
        '3prm',
        '4prm',
        '5prm',
        '1proc',
        '2proc',
        '3proc',
        '4proc'
      ],
      getItemSelected: (value) {
        sectorSelected = value;
      },
    );
    MyDropdown whoAuth = MyDropdown(
      searchController: whoController,
      labelText: 'Quem  autorizou',
      optionsList: const [
        'Maria do Rosário Fernandes',
        'Camila Nazarena Sousa',
        'Eduardo Pereira Junior',
        'Sampaio dos Santos Silva',
        'Carlos Moreira Costa',
      ],
      getItemSelected: (value) {
        whoAuthSelected = value;
      },
    );

    await showDialog(
      context: context,
      builder: (context) {
        focusNode.requestFocus();
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Informações sobre o acesso.'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 330, maxWidth: 400),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    child: goal,
                  ),
                  SizedBox(
                    child: local,
                  ),
                  SizedBox(
                    child: whoAuth,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyButton(callback: () => submit(), text: 'Registrar')
                ],
              ),
            ),
          ),
        );
      },
    );

    return [goal.fieldController.text, whoAuthSelected, sectorSelected];
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

    var validates = [
      Validatorless.required('Campo Obrigatório'),
      Validatorless.min(6, 'A senha não pode ter menos de 6 caracteres!'),
    ];

    MyFormfield passField = MyFormfield(
      labelTitle: 'Digite uma nova senha',
      listValidator: validates,
    );

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Atualizar senha',
              style: StdValues.title,
              textAlign: TextAlign.center,
            ),
            content: Form(
              key: formKey,
              child: Container(
                color: Colors.white,
                constraints:
                    const BoxConstraints(maxHeight: 260, minWidth: 300),
                child: Column(
                  children: [
                    passField,
                    const SizedBox(
                      height: 10,
                    ),
                    MyFormfield(labelTitle: 'Confirmar Senha', listValidator: [
                      ...validates,
                      Validatorless.compare(passField.fieldController,
                          'As senhas não são iguais!')
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                    MyButton(
                        callback: () {
                          if (formKey.currentState!.validate()) {
                            validate = true;
                            Navigator.pop(context);
                          }
                        },
                        text: 'Registrar'),
                  ],
                ),
              ),
            ),
          );
        });

    return [validate, passField.fieldController.text];
  }
}
