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
            title: const Center(child: Text('Histórico de acessos')),
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
                        title: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(text: 'Registro de entrada: '),
                              TextSpan(
                                text: '${visitorHistoric[index].split('|')[0]}',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 119, 0, 152)),
                              ),
                              TextSpan(
                                text:
                                    ' - ${visitorHistoric[index].split('|')[1]}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 21, 0, 209)),
                              ),
                            ],
                          ),
                        ));
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

  static Future<void> alert(BuildContext context, String titleMsg,
      {String subTitle = ''}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            titleMsg,
            textAlign: TextAlign.center,
          ),
          content: (subTitle != '')
              ? Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
          title: const Text('Finalidade do acesso.'),
          content: Builder(builder: (BuildContext context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context).requestFocus(focusNode);
            });

            return TextField(
              onSubmitted: (v) {
                if (textController.text != '') {
                  Navigator.of(context).pop();
                }
              },
              focusNode: focusNode,
              controller: textController,
            );
          }),
          actions: [
            Center(
              child: ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  if (textController.text != '') {
                    Navigator.of(context).pop();
                  }
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
