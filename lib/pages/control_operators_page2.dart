import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/services/db_manage.dart';
import 'package:acesso_mp/widgets/home/my_formfield.dart';
import 'package:acesso_mp/widgets/home/my_home_container.dart';
import 'package:acesso_mp/widgets/my_button.dart';
import 'package:acesso_mp/widgets/my_divider.dart';
import 'package:acesso_mp/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:validatorless/validatorless.dart';

class ControlOperatorsPage2 extends StatefulWidget {
  const ControlOperatorsPage2({super.key});

  @override
  State<ControlOperatorsPage2> createState() => _ControlOperatorsPage2State();
}

class _ControlOperatorsPage2State extends State<ControlOperatorsPage2> {
  bool saveUpdate = true;
  MyFormfield name = MyFormfield(
      labelText: 'Digite o nome',
      labelTitle: '  Nome',
      listValidator: [Validatorless.required('Campo Obrigatório!')]);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  MaskedTextController cpfController =
      MaskedTextController(mask: '000.000.000-00');
  MaskedTextController phoneController =
      MaskedTextController(mask: '(00) 0 0000-0000');

  MyFormfield email = MyFormfield(
      labelTitle: '  Email',
      labelText: 'Digite o email',
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

  void loadFields(Map operator) {
    name.fieldController.text = operator['name'];
    cpfController.text = operator['cpf'].toString();
    phoneController.text = operator['phone'].toString();
    email.fieldController.text = operator['email'];
    location.fieldController.text = operator['locations']['name'];
    setState(() {});
  }

  void clearFields() {
    name.fieldController.clear();
    cpfController.clear();
    phoneController.clear();
    email.fieldController.clear();
    location.fieldController.clear();
    saveUpdate = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var supabase = Supabase.instance.client;

    List operators = [];
    void updateProfile(Map data, int cpf) async {
      await supabase.from('operators').update(data).eq('cpf', cpf);
      setState(() {});
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
                                    saveUpdate
                                        ? 'Cadastrar Atendente'
                                        : 'Editar Atendente',
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          MyButton(
                                              callback: () {
                                                if (formKey.currentState!
                                                    .validate()) {}
                                              },
                                              text: saveUpdate
                                                  ? 'Cadastrar'
                                                  : 'Salvar Alterações'),
                                          MyButton(
                                              callback: () {
                                                clearFields();
                                              },
                                              text: 'Limpar')
                                        ],
                                      )
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
                            FutureBuilder(
                                future: DbManage.getOperators(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    operators = snapshot.data!;
                                  }
                                  return Expanded(
                                    child: ListView.builder(
                                        itemCount: operators.length,
                                        itemBuilder: (contex, index) {
                                          if (operators[index]['name'] ==
                                              'adm') {
                                            return const Padding(
                                                padding: EdgeInsets.zero);
                                          }
                                          return Column(
                                            children: [
                                              MyListTile(
                                                iconTip1:
                                                    'Usuário Administrador',
                                                iconTip2: 'Usuário Comum',
                                                title: operators[index]['name'],
                                                subtitle: operators[index]
                                                    ['locations']['name'],
                                                hoverColor:
                                                    const Color.fromARGB(
                                                        255, 138, 199, 248),
                                                iconBtn1: (operators[index]
                                                        ['adm'])
                                                    ? Icons.admin_panel_settings
                                                    : Icons.account_circle,
                                                iconBtn2: operators[index]
                                                        ['active']
                                                    ? Icons.check_circle_outline
                                                    : Icons
                                                        .do_not_disturb_alt_outlined,
                                                callMain: () {
                                                  saveUpdate = false;
                                                  loadFields(operators[index]);
                                                },
                                                actionBtn1: true,
                                                callIconBtn1: () {
                                                  updateProfile({
                                                    'adm': !operators[index]
                                                        ['adm']
                                                  }, operators[index]['cpf']);
                                                },
                                                callIconBtn2: () {
                                                  updateProfile({
                                                    'active': !operators[index]
                                                        ['active']
                                                  }, operators[index]['cpf']);
                                                },
                                              ),
                                              if (index < operators.length)
                                                const Divider()
                                            ],
                                          );
                                        }),
                                  );
                                }),
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
