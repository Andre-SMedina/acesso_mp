// ignore_for_file: use_build_context_synchronously

import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/services/db_manage.dart';
import 'package:acesso_mp/widgets/home/my_formfield.dart';
import 'package:acesso_mp/widgets/home/my_home_container.dart';
import 'package:acesso_mp/widgets/my_button.dart';
import 'package:acesso_mp/widgets/my_divider.dart';
import 'package:acesso_mp/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

// ignore: must_be_immutable
class ControlLocates2 extends StatefulWidget {
  const ControlLocates2({super.key});

  @override
  State<ControlLocates2> createState() => _ControlLocates2State();
}

class _ControlLocates2State extends State<ControlLocates2> {
  MyFormfield location = MyFormfield(
      focusNode: FocusNode(),
      labelText: '  Digite o nome',
      labelTitle: '  Lotação',
      listValidator: [Validatorless.required('Campo Obrigatório!')]);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var locations = [];

    return MyHomeContainer(
        difHeight: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CONTROLE DE LOTAÇÕES',
              style: StdValues.title,
            ),
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
                                    'Cadastrar Lotação',
                                    textAlign: TextAlign.center,
                                    style: StdValues.titleBox,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(30),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      location,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          MyButton(
                                              callback: () async {
                                                bool validate = false;
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  await DbManage.saveLocate(
                                                          location
                                                              .fieldController
                                                              .text)
                                                      .then((e) {
                                                    if (e) validate = true;
                                                  });

                                                  if (validate) {
                                                    location.fieldController
                                                        .clear();
                                                    setState(() {});
                                                    ZshowDialogs.alert(context,
                                                        'Cadastro realizado com sucesso!');
                                                  } else {
                                                    ZshowDialogs.alert(context,
                                                        'Lotação já cadastrada!');
                                                  }
                                                }
                                              },
                                              text: 'Cadastrar'),
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
                                  'Lista de Lotações',
                                  textAlign: TextAlign.center,
                                  style: StdValues.titleBox,
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            FutureBuilder(
                                future: MyFunctons.getLocations(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    locations = snapshot.data!;
                                  }
                                  return Expanded(
                                    child: ListView.builder(
                                        itemCount: locations.length,
                                        itemBuilder: (contex, index) {
                                          return Column(
                                            children: [
                                              MyListTile(
                                                iconTip1: '',
                                                iconTip2: '',
                                                title: locations[index]['name'],
                                                hoverColor:
                                                    const Color.fromARGB(
                                                        255, 138, 199, 248),
                                                icon: Icon(
                                                  Icons.location_city,
                                                  size: 35,
                                                  color: StdValues.btnBlue,
                                                ),
                                                callMain: () async {
                                                  await ZshowDialogs
                                                          .updateLocate(
                                                              contex,
                                                              locations[index]
                                                                  ['name'])
                                                      .then((v) {
                                                    if (v) {
                                                      MyFunctons.getLocations()
                                                          .then((e) {
                                                        MyFunctons.putHive(
                                                            'locations', e);
                                                      });
                                                      setState(() {});
                                                    }
                                                  });
                                                },
                                                actionBtn1: false,
                                                callIconBtn1: () {},
                                                callIconBtn2: () {},
                                              ),
                                              if (index < locations.length)
                                                const Divider(
                                                  height: 15,
                                                )
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
