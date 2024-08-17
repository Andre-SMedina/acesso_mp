import 'package:acesso_mp/widgets/my_drawer.dart';
import 'package:acesso_mp/widgets/my_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

class ControlLocatesPage extends StatefulWidget {
  const ControlLocatesPage({super.key});

  @override
  State<ControlLocatesPage> createState() => _ControlLocatesPageState();
}

class _ControlLocatesPageState extends State<ControlLocatesPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  MyTextField locate = MyTextField(
      text: 'Lotação',
      listValidator: [Validatorless.required('Campo obrigatório')],
      listInputFormat: const []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Controle de Lotações'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400, maxHeight: 150),
              child: Column(
                children: [
                  locate,
                  ElevatedButton(
                      onPressed: () {}, child: const Text('Cadastrar'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
