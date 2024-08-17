import 'package:acesso_mp/widgets/form_operator.dart';
import 'package:acesso_mp/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class ControlOperatorsPage extends StatefulWidget {
  const ControlOperatorsPage({super.key});

  @override
  State<ControlOperatorsPage> createState() => _ControlOperatorsPageState();
}

class _ControlOperatorsPageState extends State<ControlOperatorsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Controle de Operadores'),
        centerTitle: true,
      ),
      body: const FormOperator(),
    );
  }
}
