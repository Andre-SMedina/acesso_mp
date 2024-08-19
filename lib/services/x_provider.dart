import 'package:acesso_mp/widgets/my_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validatorless/validatorless.dart';

class XProvider with ChangeNotifier {
  String? errorText;
  TextEditingController locateController = TextEditingController();
  String? get errorText2 => errorText;
  MyTextField get name2 => name;
  MyTextField get cpf2 => cpf;
  MyTextField get phone2 => phone;
  TextEditingController get locateCotroller2 => locateController;

  void changeText() {
    errorText = 'Digite o nome da lotação para pesquisar, e escolha uma!';
    notifyListeners();
  }

  void cleanText() {
    errorText = null;
    notifyListeners();
  }

  void changeFields(Map data) {
    locateController.text = data['locations']['name'];
    name.fieldController.text = data['name'];
    notifyListeners();
    cpf.fieldController.text = data['cpf'].toString();
    notifyListeners();
    phone.fieldController.text = data['phone'].toString();
    notifyListeners();
  }

  MyTextField name = MyTextField(
    text: 'Nome',
    listInputFormat: const [],
    listValidator: [
      Validatorless.required('Campo obrigatório!'),
      (v) => v!.split(' ').length >= 2
          ? null
          : 'O nome deve ter nome e sobrenome!',
    ],
  );

  MyTextField cpf = MyTextField(
    text: 'CPF',
    listValidator: [
      Validatorless.cpf('CPF inválido!'),
      Validatorless.required('Campo obrigatório!')
    ],
    listInputFormat: [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(11)
    ],
  );

  MyTextField phone = MyTextField(
    text: 'Telefone',
    listInputFormat: [
      FilteringTextInputFormatter.digitsOnly,
    ],
    listValidator: [Validatorless.required('Campo obrigatório!')],
  );
}

// Consumer<XProvider>(
//  builder: (context, xProvider, child) {
//    return Text(xProvider.text,
//      style: const TextStyle(
//        fontSize: 16));
//}),