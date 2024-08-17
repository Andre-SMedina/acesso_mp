import 'package:acesso_mp/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class ControlLocatesPage extends StatefulWidget {
  const ControlLocatesPage({super.key});

  @override
  State<ControlLocatesPage> createState() => _ControlLocatesPageState();
}

class _ControlLocatesPageState extends State<ControlLocatesPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Controle de Lotações'),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 400, maxHeight: 100),
          child: Column(
            children: [
              TextFormField(
                controller: controller,
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(onPressed: () {}, child: const Text('Salvar'))
            ],
          ),
        ),
      ),
    );
  }
}
