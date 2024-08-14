import 'package:acesso_mp/models/x_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({super.key});

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  final List<List<String>> data = [
    ['Alice Maria das Graças', 'Formoso do Araguaia'],
    ['Bob Burnquist do Skate', 'Araguaína'],
    ['Charlie Bonovitch Garcia', 'Tocantinópolis'],
  ];

  final List<bool> _isHovered = [];

  @override
  void initState() {
    super.initState();
    _isHovered.addAll(List.generate(data.length, (index) => false));
  }

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
                    onPressed: () {
                      context.read<XProvider>().changeText();
                    },
                    child: const Text('Cadastrar operador',
                        style: TextStyle(fontSize: 16))),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Table(
                        border: TableBorder
                            .all(), // Adiciona bordas às células da tabela
                        columnWidths: const {
                          0: FlexColumnWidth(
                              2), // Define a largura da primeira coluna
                          1: FlexColumnWidth(
                              1), // Define a largura da segunda coluna
                        },
                        children: [
                          const TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Operador',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Lotação',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          ...data.asMap().entries.map((entry) {
                            int index = entry.key;
                            List<String> row = entry.value;
                            return TableRow(
                              children: row.asMap().entries.map((cellEntry) {
                                int cellIndex = cellEntry.key;
                                String cell = cellEntry.value;
                                return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: cellIndex == 0
                                        ? MouseRegion(
                                            onEnter: (event) {
                                              setState(() {
                                                _isHovered[index] = true;
                                              });
                                            },
                                            onExit: (event) {
                                              setState(() {
                                                _isHovered[index] = false;
                                              });
                                            },
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () => print('oi'),
                                              child: Text(
                                                cell,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: _isHovered[index]
                                                      ? const Color.fromARGB(
                                                          255, 0, 2, 150)
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Consumer<XProvider>(builder:
                                            (context, xProvider, child) {
                                            return Text(xProvider.text,
                                                style: const TextStyle(
                                                    fontSize: 16));
                                          }));
                              }).toList(),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
