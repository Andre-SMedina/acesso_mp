import 'package:acesso_mp/widgets/home_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive/hive.dart';
import 'package:validatorless/validatorless.dart';

class ZshowDialogs {
  static Future<void> historic(
      BuildContext context, List<String> visitor) async {
    var box = Hive.box('db');
    var checked = box.get('visitor');

    if (checked != null && checked != '') {
      var visitorHistoric = checked['visits'];

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
                    return ListTile(
                        leading: const Icon(Icons
                            .check_circle_outline_outlined), // Ícone opcional para cada item
                        title: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(text: 'Registro de entrada: '),
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

  static Future<bool> update(BuildContext context) async {
    bool validate = false;

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Deseja atualizar os dados?'),
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

  static void operatorRegister(BuildContext context) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController searchController = TextEditingController();

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Cadastro de operador',
              textAlign: TextAlign.center,
            ),
            content: Form(
              key: formKey,
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 500, minWidth: 400),
                child: Column(
                  children: [
                    ModelHomeFields(
                      text: 'Nome',
                      listInputFormat: const [],
                      listValidator: [
                        Validatorless.required('Campo obrigatório!'),
                        (v) => v!.split(' ').length >= 2
                            ? null
                            : 'O nome deve ter nome e sobrenome!',
                      ],
                    ),
                    ModelHomeFields(
                      text: 'CPF',
                      listValidator: [
                        Validatorless.cpf('CPF inválido!'),
                        Validatorless.required('Campo obrigatório!')
                      ],
                      listInputFormat: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11)
                      ],
                    ),
                    ModelHomeFields(
                      text: 'Telefone',
                      listInputFormat: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      listValidator: [
                        Validatorless.required('Campo obrigatório!')
                      ],
                    ),
                    TypeAheadField(
                      controller: searchController,
                      emptyBuilder: (context) => const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Nenhum resultado encontrado'),
                      ),
                      builder: (context, controller, focusNode) {
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              border: OutlineInputBorder(),
                              labelText: 'Lotação'),
                        );
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      suggestionsCallback: (search) {
                        List<String> listDropdown = [];

                        if (search.length > 2) {
                          List<String> listFull = [
                            'Araguaína',
                            'Palmas(Sede)',
                            'Palmas(Anexo)'
                          ];

                          listDropdown = listFull.where((e) {
                            return e
                                .toLowerCase()
                                .contains(search.toLowerCase());
                          }).toList();
                        }

                        return listDropdown;
                      },
                      onSelected: (suggestion) {
                        searchController.text = suggestion;
                      },
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {}, child: const Text('Cadastrar')),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
