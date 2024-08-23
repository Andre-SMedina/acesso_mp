// ignore_for_file: use_build_context_synchronously

import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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

  void _login(BuildContext context) async {
    final supabase = Supabase.instance.client;
    final operators = await supabase
        .from('operators')
        .select('userName, email, active, newUser');

    // return;

    if (_formKey.currentState!.validate()) {
      // if (true) {
      bool validate = false;
      String email = '';
      bool auth = false;
      bool activate = false;
      bool newUser = false;

      for (var e in operators) {
        if (e.containsValue(emailController.text)) {
          email = e['email'];
          activate = e['active'];
          newUser = e['newUser'];
          validate = true;
        }
      }

      if (!validate) {
        return ZshowDialogs.alert(context, 'Usuário não encontrado!');
      }
      if (passwordController.text == '123456' && newUser) {
        await ZshowDialogs.updatePassword(context).then((e) {
          validate = e;
        });

        if (validate) {
          ZshowDialogs.alert(context, 'Senha atualizada com sucesso!');
          try {
            await supabase.auth
                .signUp(email: email, password: passwordController.text);
            await supabase
                .from('operators')
                .update({'active': true, 'newUser': false}).eq('email', email);
            // await supabase.auth.signInWithPassword(
            //     email: email, password: passwordController.text);
            auth = true;
          } catch (err) {
            debugPrint(err.toString());
          }
        }
      } else {
        try {
          await supabase.auth.signInWithPassword(
              email: email, password: passwordController.text);

          auth = true;
        } catch (err) {
          debugPrint(err.toString());
        }
      }

      if (auth) {
        Navigator.pushReplacementNamed(context, '/home');
        // _formKey.currentState!.reset();
      } else {
        ZshowDialogs.alert(context, 'Email ou senha incorreto!');
      }
    }
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
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'E-mail',
                          helperText: ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu e-mail';
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
