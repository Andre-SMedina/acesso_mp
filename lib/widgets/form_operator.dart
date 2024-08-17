import 'dart:async';

import 'package:acesso_mp/models/x_provider.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/widgets/home_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class FormOperator extends StatefulWidget {
  const FormOperator({super.key});

  @override
  State<FormOperator> createState() => _FormOperatorState();
}

class _FormOperatorState extends State<FormOperator> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController searchController = TextEditingController();

    return Form(
      key: formKey,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
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
                listValidator: [Validatorless.required('Campo obrigatório!')],
              ),
              TypeAheadField(
                loadingBuilder: (context) => const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Buscando...'),
                ),
                controller: searchController,
                emptyBuilder: (context) => const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('Nenhum resultado encontrado'),
                ),
                builder: (context, controller, focusNode) {
                  return Consumer<XProvider>(builder: (context, value, child) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      validator: (e) {
                        if (e == '') {
                          // Timer(const Duration(seconds: 4), () {
                          //   context.read<XProvider>().changeText();
                          // });
                          return 'kkk';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          errorText: value.helperText,
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
                  });
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                suggestionsCallback: (search) {
                  List<String> listDropdown = [];
                  context.read<XProvider>().changeText();

                  if (search.length > 2) {
                    List<String> listFull = [
                      'Araguaína',
                      'Palmas(Sede)',
                      'Palmas(Anexo)'
                    ];

                    listDropdown = listFull.where((e) {
                      return Convert.removeAccent(e.toLowerCase())
                          .contains(Convert.removeAccent(search.toLowerCase()));
                    }).toList();
                  }

                  return listDropdown;
                },
                onSelected: (suggestion) {
                  searchController.text = suggestion;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Timer(const Duration(seconds: 3), () {
                          print('fala');
                          context.read<XProvider>().changeText();
                        });
                        if (formKey.currentState!.validate()) {
                          print('ok');
                        }
                      },
                      child: const Text('Cadastrar')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
