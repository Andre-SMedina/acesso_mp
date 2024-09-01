import 'package:acesso_mp/widgets/my_appbar.dart';
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
      appBar: myAppbar(context, 'Controle de Acesso ao Ministério Público'),
    );
  }
}
