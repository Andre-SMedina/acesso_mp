import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/widgets/home_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:validatorless/validatorless.dart';

class FormOperator extends StatelessWidget {
  const FormOperator({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController searchController = TextEditingController();

    return Form(
      key: formKey,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 400, minWidth: 400),
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
              listValidator: [Validatorless.required('Campo obrigatório!')],
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
                  validator: Validatorless.required('Campo obrigatório!'),
                  decoration: const InputDecoration(
                      helperText: '',
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
    );
  }
}
