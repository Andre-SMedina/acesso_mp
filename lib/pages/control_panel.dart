import 'package:acesso_mp/widgets/item_control_panel.dart';
import 'package:flutter/material.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({super.key});

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Painel de Controle'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {}, child: const Text('Cadastrar operador')),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 30),
                  constraints: const BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(width: 1),
                  ),
                  // ignore: prefer_const_constructors
                  child: Column(
                    children: const [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('OPERADOR',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('SETOR',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Divider(
                        thickness: 1.5,
                        color: Colors.black,
                      ),
                      ItemControlPanel(
                          operator: 'Maria Clara das Neves',
                          sector: 'Formoso do Araguaia'),
                      ItemControlPanel(
                          operator: 'Maria Clara', sector: 'Gurupi'),
                      ItemControlPanel(
                          operator: 'José Roberto dos Santos',
                          sector: 'Babaçulândia'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
