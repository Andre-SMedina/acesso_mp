import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:acesso_mp/services/db_manage.dart';
import 'package:acesso_mp/widgets/my_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:validatorless/validatorless.dart';

class ZshowDialogs {
  static Future<void> historic(
      BuildContext context, List<String> visitor) async {
    var checked = MyFunctons.getHive('visitor');

    if (checked != null && checked != '') {
      var visitorHistoric = checked['visits'];

      Future<dynamic> getOperator(int idOperator) async {
        SupabaseClient supabase = Supabase.instance.client;
        var operator = await supabase
            .from('operator')
            .select('*, operators(name)')
            .eq('id_operator', idOperator);

        return operator;
      }

      await showDialog(
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
                    List operators = MyFunctons.getHive('operators');

                    for (var i = 0; i < operators.length; i++) {
                      if (operators[i]['id'] ==
                          visitorHistoric[index]['id_operator']) {
                        operator = operators[i]['name'];
                      }
                    }

                    // getOperator(visitorHistoric[index]['id_operator'])
                    //     .then((e) {
                    //   print(e);
                    // });
                    return ListTile(
                        leading: const Icon(Icons
                            .check_circle_outline_outlined), // Ícone opcional para cada item
                        title: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: 'Operador: $operator '),
                              TextSpan(
                                text: '${visitorHistoric[index]['date']}',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 119, 0, 152)),
                              ),
                              TextSpan(
                                text: ' - ${visitorHistoric[index]['goal']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 21, 0, 209)),
                              ),
                            ],
                          ),
                        ));
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

  static Future<String> visited(BuildContext context) async {
    late TextEditingController textController = TextEditingController();
    FocusNode focusNode = FocusNode();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Finalidade do acesso.'),
          content: Builder(builder: (BuildContext context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context).requestFocus(focusNode);
            });

            return TextField(
              onSubmitted: (v) {
                if (textController.text != '') {
                  Navigator.of(context).pop();
                }
              },
              focusNode: focusNode,
              controller: textController,
            );
          }),
          actions: [
            Center(
              child: ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  if (textController.text != '') {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        );
      },
    );

    return textController.text;
  }

  static Future<bool> confirm(BuildContext context, String title) async {
    bool validate = false;

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
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

    MyTextField nameField = MyTextField(
        text: 'Novo nome',
        listValidator: [Validatorless.required('Campo obrgatório!')],
        listInputFormat: const []);

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
                  nameField,
                  ElevatedButton(
                      onPressed: () async {
                        String newName = nameField.fieldController.text;

                        if (newName.isNotEmpty) {
                          await DbManage.update(
                              column: 'name',
                              data: {'name': newName},
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
