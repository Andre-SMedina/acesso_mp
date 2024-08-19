import 'dart:async';

import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/services/x_provider.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/services/db_manage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FormOperator extends StatefulWidget {
  final VoidCallback callback;
  const FormOperator({super.key, required this.callback});

  @override
  State<FormOperator> createState() => _FormOperatorState();
}

class _FormOperatorState extends State<FormOperator> {
  String locate = '';

  Map loadData(String name, String cpf, String phone) {
    return {'name': name, 'cpf': cpf, 'phone': phone};
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController locateController = TextEditingController();

    return Form(
      key: formKey,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
          child: Consumer<XProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  provider.name,
                  provider.cpf,
                  provider.phone,
                  TypeAheadField(
                    loadingBuilder: (context) => const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Buscando...'),
                    ),
                    controller: provider.locateController,
                    emptyBuilder: (context) => const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Nenhum resultado encontrado'),
                    ),
                    builder: (context, controller, focusNode) {
                      return Consumer<XProvider>(
                          builder: (context, provider, child) {
                        return Column(
                          children: [
                            TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              validator: (e) {
                                if (e == '' || locate == '') {
                                  context.read<XProvider>().changeText();
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  errorText: provider.errorText,
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  border: const OutlineInputBorder(),
                                  labelText: 'Lotação'),
                            ),
                          ],
                        );
                      });
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    suggestionsCallback: (search) async {
                      List<dynamic> listFull = [];
                      List<dynamic> listDropdown = [];

                      if (search.length > 2) {
                        await DbManage.getLocations().then((value) {
                          listFull = value.map((e) {
                            return e['name'];
                          }).toList();
                        });
                        listDropdown = listFull.where((e) {
                          return Convert.removeAccent(e.toLowerCase()).contains(
                              Convert.removeAccent(search.toLowerCase()));
                        }).toList();
                      }

                      return listDropdown;
                    },
                    onSelected: (suggestion) {
                      locate = suggestion;
                      provider.locateController.text = suggestion;
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate() &&
                                locate != '') {
                              bool response = false;

                              await DbManage.saveOperator(
                                      loadData(
                                          provider.name.fieldController.text,
                                          provider.cpf.fieldController.text,
                                          provider.phone.fieldController.text),
                                      locate)
                                  .then((e) {
                                if (e) response = true;
                              });

                              if (response) {
                                formKey.currentState!.reset();
                                locate = '';
                                provider.locateController.text = '';
                                ZshowDialogs.alert(context,
                                    'Operador cadastrado com sucesso!');
                                setState(() {});

                                widget.callback();
                              }
                            } else {
                              Timer(const Duration(seconds: 3), () {
                                context.read<XProvider>().cleanText();
                              });
                            }
                          },
                          child: const Text('Cadastrar')),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Salvar')),
                      ElevatedButton(
                          onPressed: () {
                            provider.name.fieldController.text = '';
                            provider.cpf.fieldController.text = '';
                            provider.phone.fieldController.text = '';
                            locate = '';
                            provider.locateController.text = '';
                            widget.callback();
                          },
                          child: const Text('Limpar'))
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
