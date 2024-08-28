// ignore_for_file: use_build_context_synchronously

import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final MaskedTextController testeController =
      MaskedTextController(mask: '000.000.000-00');
  final FocusNode emailFocus = FocusNode();

  void _login(BuildContext context) async {
    final supabase = Supabase.instance.client;
    final operators = await supabase.from('operators').select(
        'id, name, userName, email, active, newUser, adm, locations(*)');

    if (_formKey.currentState!.validate()) {
      if (emailController.text == 'adm') {
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
        if (e.containsValue(emailController.text)) {
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
        if (!mounted) return;
        emailFocus.dispose();
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ZshowDialogs.alert(context, 'Email ou senha incorreto!');
      }
    }
  }

  @override
  void dispose() {
    // emailFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //aguarda a montagem do widget para depois requisitar o foco
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) emailFocus.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/mp.jpg'),
              fit: BoxFit.cover,
              opacity: 0.2),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Container(
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      focusNode: emailFocus,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Usuário',
                          helperText: ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu usuário';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      onFieldSubmitted: (e) => _login(context),
                      controller: passwordController,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Senha',
                          helperText: ''),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua senha';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _login(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Logar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
