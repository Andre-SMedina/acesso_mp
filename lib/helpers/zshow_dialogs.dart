import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ZshowDialogs {
  static Future<void> historic(
      BuildContext context, List<String> visitor) async {
    var box = Hive.box('db');
    var checked = box.get('visitor');

    if (checked != null && checked != '') {
      var visitorHistoric = checked['visit'];

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text('Histórico de visitas')),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap:
                      true, // Permite que a lista ocupe o espaço mínimo necessário
                  itemCount:
                      visitorHistoric.length, // Número de elementos na lista
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons
                          .check_circle_outline_outlined), // Ícone opcional para cada item
                      title: Text(
                          'Registro de entrada: ${visitorHistoric[index]}'),
                    );
                  },
                ),
              ),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }

  static Future<void> alert(BuildContext context, String titleMsg) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titleMsg),
          actions: [
            Center(
              child: ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<String> visited(BuildContext context) async {
    late TextEditingController textController = TextEditingController();
    FocusNode focusNode = FocusNode();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quem visitar?'),
          content: Builder(builder: (BuildContext context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context).requestFocus(focusNode);
            });

            return TextField(
              focusNode: focusNode,
              controller: textController,
            );
          }),
          actions: [
            Center(
              child: ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );

    return textController.text;
  }
}
