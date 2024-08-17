import 'package:flutter/material.dart';

class XProvider with ChangeNotifier {
  String? helperText;

  String? get text => helperText;

  void changeText() {
    helperText = null;
    notifyListeners();
  }

  Future<void> alert(BuildContext context, String titleMsg,
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
}

// Consumer<XProvider>(
//  builder: (context, xProvider, child) {
//    return Text(xProvider.text,
//      style: const TextStyle(
//        fontSize: 16));
//}),