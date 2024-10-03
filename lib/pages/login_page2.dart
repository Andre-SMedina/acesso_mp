// ignore_for_file: use_build_context_synchronously

import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/services/x_provider.dart';
import 'package:acesso_mp/widgets/my_button.dart';
import 'package:acesso_mp/widgets/my_formfield_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage2 extends StatelessWidget {
  LoginPage2({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login(BuildContext context) async {
    final supabase = Supabase.instance.client;
    final operators = await supabase.from('operators').select(
        'id, name, userName, email, active, newUser, adm, change_password, password, locations(*)');

    if (_formKey.currentState!.validate()) {
      bool validate = false;
      String newPassword = '';
      late Map user;

      for (var e in operators) {
        if (e.containsValue(userController.text)) {
          validate = true;
          MyFunctons.putHive('profile', e);
          user = e;
        }
      }

      if (!validate) {
        return ZshowDialogs.alert(context, 'Usuário não encontrado!');
      }
      if (user['newUser']) {
        await ZshowDialogs.updatePassword(context).then((e) {
          validate = e[0];
          newPassword = e[1];
        });

        if (validate) {
          await supabase.from('operators').update({
            'password': newPassword,
            'active': true,
            'newUser': false
          }).eq('email', user['email']);
        }
      }

      if (user['change_password']) {
        await ZshowDialogs.updatePassword(context).then((e) {
          validate = e[0];
          newPassword = e[1];
        });

        if (validate) {
          await supabase
              .from('operators')
              .update({'change_password': false, 'password': newPassword}).eq(
                  'email', user['email']);
          user['password'] = newPassword;
          passwordController.text = newPassword;
        } else {
          return ZshowDialogs.alert(context, 'É necessário redefinir a senha!');
        }
      }

      if (!user['active']) {
        return ZshowDialogs.alert(context, 'Usuário desativado');
      }
      if (user['password'] == passwordController.text) {
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
