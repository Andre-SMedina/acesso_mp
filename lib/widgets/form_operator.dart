import 'dart:async';

import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/services/x_provider.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/services/db_manage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ignore: must_be_immutable
class FormOperator extends StatefulWidget {
  final VoidCallback callback;
  FormOperator({super.key, required this.callback});

  @override
  State<FormOperator> createState() => _FormOperatorState();
}

class _FormOperatorState extends State<FormOperator> {
  String locate = '';
  List<dynamic> listFull = [];

  Map loadData(String name, String cpf, String phone) {
    return {'name': name, 'cpf': cpf, 'phone': phone};
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                                if (e == '' ||
                                    provider.locateController.text == '' ||
                                    !listFull.contains(
                                        provider.locateController.text)) {
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
                      List<dynamic> listDropdown = [];

                      if (search.length > 2) {
                        var box = Hive.box('db');
                        listFull = box.get('locations');

                        listDropdown = listFull.where((e) {
                          return Convert.removeAccent(e.toLowerCase()).contains(
                              Convert.removeAccent(search.toLowerCase()));
                        }).toList();
                      }

                      return listDropdown;
                    },
                    onSelected: (suggestion) {
                      // locate = suggestion;
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
                                listFull
                                    .contains(provider.locateController.text)) {
                              bool response = false;

                              await DbManage.saveOperator(
                                      loadData(
                                          provider.name.fieldController.text,
                                          provider.cpf.fieldController.text,
                                          provider.phone.fieldController.text),
                                      provider.locateController.text)
                                  .then((e) {
                                if (e) response = true;
                              });

                              if (response) {
                                formKey.currentState!.reset();
                                provider.locateController.text = '';
                                // ignore: use_build_context_synchronously
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
                          onPressed: () async {
                            if (formKey.currentState!.validate() &&
                                listFull
                                    .contains(provider.locateController.text)) {
                              SupabaseClient supabase =
                                  Supabase.instance.client;
                              var location = await supabase
                                  .from('locations')
                                  .select()
                                  .eq('name', provider.locateController.text);

                              Map operator = {
                                'name': provider.name.fieldController.text,
                                'cpf': provider.cpf.fieldController.text,
                                'phone': provider.phone.fieldController.text,
                                'location': location[0]['id']
                              };

                              operator['name'] =
                                  provider.name.fieldController.text;
                              operator['phone'] =
                                  provider.phone.fieldController.text;
                              operator['location'] = location[0]['id'];

                              DbManage.update(
                                data: operator,
                                table: 'operators',
                                column: 'cpf',
                                find: operator['cpf'],
                                boxName: 'operator',
                              );

                              widget.callback();
                            } else {
                              Timer(const Duration(seconds: 3), () {
                                context.read<XProvider>().cleanText();
                              });
                            }
                          },
                          child: const Text('Salvar')),
                      ElevatedButton(
                          onPressed: () {
                            context.read<XProvider>().clearFields();
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
