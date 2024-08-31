import 'package:acesso_mp/widgets/my_button.dart';
import 'package:acesso_mp/widgets/my_formfield.dart';
import 'package:flutter/material.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            height: double.infinity,
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 233,
                  height: 107.57,
                  decoration: const BoxDecoration(color: Colors.blue),
                ),
                SizedBox(
                  height: 60,
                ),
                const Text('Bem vindo(a) ao Sistema AcessoMP',
                    style: TextStyle(fontSize: 20)),
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                    width: 450,
                    child: MyFormfield(
                      text: 'Usuário',
                      icon: Icon(
                        Icons.person_outline,
                        size: 27,
                      ),
                    )),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(width: 450, child: TextFormField()),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                    width: 120,
                    height: 42,
                    child: MyButton(callback: () {}, text: 'Entrar')),
              ],
            ),
          ),
          Container(
            height: double.infinity,
            width: MediaQuery.of(context).size.width / 2,
            decoration: const BoxDecoration(color: Colors.blue),
          )
        ],
      ),
    );
  }
}
