import 'dart:async';

import 'package:acesso_mp/models/x_provider.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/widgets/my_text_fields.dart';
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
              MyTextField(
                text: 'Nome',
                listInputFormat: const [],
                listValidator: [
                  Validatorless.required('Campo obrigatório!'),
                  (v) => v!.split(' ').length >= 2
                      ? null
                      : 'O nome deve ter nome e sobrenome!',
                ],
              ),
              MyTextField(
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
              MyTextField(
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
                  return Consumer<XProvider>(
                      builder: (context, provider, child) {
                    return Column(
                      children: [
                        TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          validator: (e) {
                            if (e == '') {
                              context.read<XProvider>().changeText();
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              errorText: provider.errorText,
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              border: OutlineInputBorder(),
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
                suggestionsCallback: (search) {
                  List<String> listDropdown = [];
                  context.read<XProvider>().cleanText();

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
                height: 25,
              ),
              ElevatedButton(
                  onPressed: () {
                    Timer(const Duration(seconds: 3), () {
                      context.read<XProvider>().cleanText();
                    });
                    if (formKey.currentState!.validate()) {
                      print('ok');
                    }
                  },
                  child: const Text('Cadastrar'))
            ],
          ),
        ),
      ),
    );
  }
}
