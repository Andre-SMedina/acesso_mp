// ignore_for_file: use_build_context_synchronously

import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/pages/control_operators_functions.dart';
import 'package:acesso_mp/services/db_manage.dart';
import 'package:acesso_mp/widgets/home/my_formfield.dart';
import 'package:acesso_mp/widgets/home/my_home_container.dart';
import 'package:acesso_mp/widgets/my_button.dart';
import 'package:acesso_mp/widgets/my_divider.dart';
import 'package:acesso_mp/widgets/my_dropdown.dart';
import 'package:acesso_mp/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:validatorless/validatorless.dart';

// ignore: must_be_immutable
class ControlOperatorsPage2 extends StatefulWidget {
  ControlOperatorsPage2({super.key});
  FocusNode focusNode = FocusNode();

  @override
  State<ControlOperatorsPage2> createState() => _ControlOperatorsPage2State();
}

class _ControlOperatorsPage2State extends State<ControlOperatorsPage2> {
  bool saveUpdate = true;
  String selectedLocation = '';
  TextEditingController searchControler = TextEditingController();

  MyFormfield name = MyFormfield(
      focusNode: FocusNode(),
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

  @override
  Widget build(BuildContext context) {
    var supabase = Supabase.instance.client;
    name.focusNode!.requestFocus();

    List operators = [];
    List locations = MyFunctons.getHive('locationsName');

    MyDropdown dropdown = MyDropdown(
        searchController: searchControler,
        optionsList: locations,
        getItemSelected: (itemSelected) {
          selectedLocation = itemSelected;
        },
        labelText: 'Selecione uma cidade');

    void loadFields(Map operator) {
      formKey.currentState!.reset();
      dropdown.searchController!.text = operator['locations']['name'];
      selectedLocation = operator['locations']['name'];
      name.fieldController.text = operator['name'];
      cpfController.text = operator['cpf'];
      phoneController.text = operator['phone'];
      email.fieldController.text = operator['email'];
      setState(() {});
    }

    void clearFields() {
      formKey.currentState!.reset();
      name.fieldController.clear();
      cpfController.clear();
      phoneController.clear();
      email.fieldController.clear();
      dropdown.searchController!.clear();
      selectedLocation = '';
      saveUpdate = true;
      setState(() {});
    }

    Map<String, String> dataFields() {
      return {
        'name': name.fieldController.text,
        'cpf': cpfController.text.replaceAll(RegExp(r'\D'), ''),
        'phone': phoneController.text.replaceAll(RegExp(r'\D'), ''),
        'email': email.fieldController.text
      };
    }

    void updateProfile(Map data, String cpf) async {
      await supabase.from('operators').update(data).eq('cpf', cpf);
      setState(() {});
    }

    void reload() {
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
                                      dropdown,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          MyButton(
                                              callback: () async {
                                                if (formKey.currentState!
                                                        .validate() &&
                                                    selectedLocation
                                                        .isNotEmpty) {
                                                  bool validate = false;
                                                  if (saveUpdate) {
                                                    await DbManage.saveOperator(
                                                            dataFields(),
                                                            selectedLocation)
                                                        .then((e) {
                                                      if (e) validate = true;
                                                    });
                                                  }

                                                  if (validate) {
                                                    clearFields();
                                                    ZshowDialogs.alert(context,
                                                        'Operador cadastrado com sucesso!');
                                                    setState(() {});
                                                  } else {
                                                    ZshowDialogs.alert(context,
                                                        'CPF já cadastrado.');
                                                  }
                                                  saveUpdate = true;
                                                  setState(() {});
                                                } else {
                                                  ZshowDialogs.alert(context,
                                                      'Preencha todos os campos!');
                                                }
                                              },
                                              text: 'Cadastrar'),
                                          MyButton(
                                              callback: () async {
                                                if (formKey.currentState!
                                                        .validate() &&
                                                    selectedLocation
                                                        .isNotEmpty) {
                                                  ControlOperatorsFunctions
                                                      .update(
                                                          context: context,
                                                          reload: reload,
                                                          data: dataFields(),
                                                          location:
                                                              selectedLocation);
                                                } else {
                                                  ZshowDialogs.alert(context,
                                                      'Preencha todos os campos!');
                                                }
                                              },
                                              text: 'Salvar Alterações'),
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
                                                callIconPass: () {
                                                  print('kkk');
                                                  updateProfile({
                                                    'change_password': true,
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
