// ignore_for_file: use_build_context_synchronously

import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/services/x_provider.dart';
import 'package:acesso_mp/widgets/my_button.dart';
import 'package:acesso_mp/widgets/my_formfield_login.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage2 extends StatelessWidget {
  LoginPage2({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // final FocusNode emailFocus = FocusNode();

  void _login(BuildContext context) async {
    final supabase = Supabase.instance.client;
    final operators = await supabase.from('operators').select(
        'id, name, userName, email, active, newUser, adm, locations(*)');

    if (_formKey.currentState!.validate()) {
      if (userController.text == 'adm') {
        await supabase.auth.signInWithPassword(
            email: 'adm@adm.com', password: passwordController.text);
      }
      var box = Hive.box('db');
      bool validate = false;
      String email = '';
      bool auth = false;
      bool active = false;
      bool newUser = false;
      String userName = '';
      String password = '';

      for (var e in operators) {
        if (e.containsValue(userController.text)) {
          email = e['email'];
          active = e['active'];
          newUser = e['newUser'];
          validate = true;
          userName = e['userName'];
          box.put('profile', e);
        }
      }

      if (!validate) {
        return ZshowDialogs.alert(context, 'Usuário não encontrado!');
      }
      if (newUser) {
        await ZshowDialogs.updatePassword(context).then((e) {
          validate = e[0];
          password = e[1];
        });

        if (validate) {
          try {
            await supabase.auth.signUp(
              email: email,
              password: password,
            );
            await supabase
                .from('operators')
                .update({'active': true, 'newUser': false}).eq('email', email);
            await supabase.auth.updateUser(UserAttributes(data: {
              'displayName': userName,
            }));
            auth = true;
          } catch (err) {
            debugPrint(err.toString());
          }
        }
      } else {
        if (!active) {
          return ZshowDialogs.alert(context, 'Usuário desativado');
        }
        try {
          await supabase.auth.signInWithPassword(
              email: email, password: passwordController.text);

          auth = true;
        } catch (err) {
          debugPrint(err.toString());
        }
      }

      if (auth) {
        MyFunctons.getOperators().then((e) {
          MyFunctons.putHive('operators', e);
        });
        MyFunctons.getLocations().then((e) {
          MyFunctons.putHive('locations', e);
        });
        Navigator.pushNamed(context, '/home');
      } else {
        ZshowDialogs.alert(context, 'Email ou senha incorreto!');
      }
    }
  }

  // @override
  // void dispose() {
  //   emailFocus.dispose();
  //   super.dispose();
  // }

  // @override
  // void initState() {
  //   super.initState();
  // aguarda a montagem do widget para depois requisitar o foco
  // WidgetsBinding.instance.addPostFrameCallback((_) {
  // if (mounted) emailFocus.requestFocus();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          SizedBox(
            height: double.infinity,
            width: MediaQuery.of(context).size.width / 2,
            child: Consumer<XProvider>(
              builder: (context, provider, child) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 350,
                        height: 163,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          filterQuality: FilterQuality.high,
                          image: AssetImage('assets/logo2.png'),
                        )),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const Text('Bem vindo(a) ao Sistema AcessoMP',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF7D7D7D),
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 80,
                      ),
                      SizedBox(
                          width: 450,
                          child: MyFormfieldLogin(
                            call: (String value) {},
                            erroText: 'Por favor, insira seu usuário',
                            controller: userController,
                            text: 'Usuário',
                            icon: const Icon(
                              Icons.person_outline,
                              color: Color.fromARGB(255, 116, 116, 116),
                              size: 27,
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: 450,
                          child: MyFormfieldLogin(
                            call: (String value) {
                              _login(context);
                            },
                            erroText: 'Por favor, insira sua senha',
                            controller: passwordController,
                            passwd: provider.passwd,
                            text: 'Senha',
                            iconBtn: IconButton(
                                onPressed: () {
                                  context.read<XProvider>().passwdChange();
                                  context.read<XProvider>().passwdIconChange();
                                },
                                icon: provider.passwdIcon),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: 120,
                          height: 42,
                          child: MyButton(
                              callback: () {
                                _login(context);
                              },
                              text: 'Entrar')),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            height: double.infinity,
            width: MediaQuery.of(context).size.width / 2,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/entrada.jpeg'),
                    fit: BoxFit.cover,
                    opacity: 1)),
          )
        ],
      ),
    );
  }
}
