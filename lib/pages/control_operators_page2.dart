import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/widgets/home/my_formfield.dart';
import 'package:acesso_mp/widgets/home/my_home_container.dart';
import 'package:acesso_mp/widgets/my_button.dart';
import 'package:acesso_mp/widgets/my_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:validatorless/validatorless.dart';

class ControlOperatorsPage2 extends StatelessWidget {
  const ControlOperatorsPage2({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    MaskedTextController cpfController =
        MaskedTextController(mask: '000.000.000-00');
    MaskedTextController phoneController =
        MaskedTextController(mask: '(00) 0 0000-0000');

    MyFormfield name = MyFormfield(
        labelText: 'Digite o nome',
        labelTitle: '  Nome',
        listValidator: [Validatorless.required('Campo Obrigatório!')]);

    MyFormfield email = MyFormfield(
        labelTitle: '  Email',
        labelText: 'Digite o emai',
        listValidator: [
          Validatorless.required('Campo Obrigatório!'),
          Validatorless.email('Email inválido!')
        ]);
    MyFormfield location = MyFormfield(
        labelTitle: '  Lotação',
        labelText: 'Escoha a lotação',
        listValidator: [
          Validatorless.required('Campo Obrigatório!'),
        ]);

    List<Widget> operatorsList() {
      List<Widget> lista = [];
      Icon adm = Icon(
        Icons.admin_panel_settings,
        color: Colors.yellow,
        size: 50,
      );
      Icon comum = Icon(
        Icons.account_circle,
        color: StdValues.bkgBlue,
        size: 50,
      );
      Icon actived = Icon(
        Icons.check_circle_outline,
        color: StdValues.bkgBlue,
        size: 50,
      );

      for (var i = 0; i < 15; i++) {
        lista.add(Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          color: (i % 2 == 0) ? StdValues.bkgGrey : Colors.white,
          child: ListTile(
            leading: comum,
            trailing: actived,
            title: const Text('Nome do Atendente',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text(
              'Cidade',
              textAlign: TextAlign.center,
            ),
          ),
        ));
      }

      return lista;
    }

    return MyHomeContainer(
        difHeight: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CONTROLE DE ATENDENTES',
                textAlign: TextAlign.start, style: StdValues.title),
            const MyDivider(),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: StdValues.boxShadow,
                        margin: const EdgeInsets.only(right: 30),
                        height: constraints.maxHeight * 0.68,
                        width: constraints.maxWidth * 0.45,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: StdValues.boxBar,
                                  width: double.infinity,
                                  child: Text(
                                    'Cadastrar Atendente',
                                    textAlign: TextAlign.center,
                                    style: StdValues.titleBox,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(30),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      name,
                                      Row(
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: MyFormfield(
                                                labelTitle: '  CPF',
                                                labelText: 'Digite o CPF',
                                                maskedController: cpfController,
                                                listValidator: [
                                                  Validatorless.required(
                                                      'Campo Obrigatório!'),
                                                  Validatorless.cpf(
                                                      'CPF inválido!')
                                                ]),
                                          ),
                                          const SizedBox(
                                            width: 50,
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: MyFormfield(
                                                labelTitle: '  Telefone',
                                                labelText: 'Digite o telefone',
                                                maskedController:
                                                    phoneController,
                                                listValidator: [
                                                  Validatorless.required(
                                                      'Campo Obrigatório!')
                                                ]),
                                          )
                                        ],
                                      ),
                                      email,
                                      location,
                                      MyButton(
                                          callback: () {
                                            if (formKey.currentState!
                                                .validate()) {}
                                          },
                                          text: 'Cadastrar')
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: StdValues.boxShadow,
                        height: constraints.maxHeight * 0.92,
                        width: constraints.maxWidth * 0.45,
                        child: Column(
                          children: [
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: StdValues.boxBar,
                                width: double.infinity,
                                child: Text(
                                  'Lista de Atendentes',
                                  textAlign: TextAlign.center,
                                  style: StdValues.titleBox,
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: operatorsList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
            )
          ],
        ));
  }
}
