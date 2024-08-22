import 'package:acesso_mp/widgets/my_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:validatorless/validatorless.dart';

class XProvider with ChangeNotifier {
  String? errorText;
  TextEditingController locateController = TextEditingController();
  bool enableField = true;
  bool get enableField2 => enableField;
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

  void loadVisitorsField(Map<String, dynamic> visitor) {
    name.fieldController.text = visitor['name'];
    cpf.fieldController.text = "${visitor['cpf'].substring(0, 5)}...";
    rg.fieldController.text = visitor['rg'];
    phone.fieldController.text = visitor['phone'];
    job.fieldController.text = visitor['job'];
    cpf.enableField = false;
    rg.enableField = false;
    cpf.listValidator[0] = Validatorless.multiple([]);
    notifyListeners();
  }

  void clearFields() {
    name.fieldController.text = '';
    cpf.fieldController.text = '';
    rg.fieldController.text = '';
    phone.fieldController.text = '';
    job.fieldController.text = '';
    email.fieldController.text = '';
    locateController.text = '';
    cpf.enableField = true;
    rg.enableField = true;
    cpf.listValidator[0] = Validatorless.cpf('CPF inválido!');
    var box = Hive.box('db');
    box.putAll({'visitor': '', 'image': ''});
    notifyListeners();
  }

  void loadOperatorField(Map operator) {
    locateController.text = operator['locations']['name'];
    name.fieldController.text = operator['name'];
    cpf.fieldController.text = operator['cpf'].toString();
    phone.fieldController.text = operator['phone'].toString();
    email.fieldController.text = operator['email'];
    cpf.enableField = false;

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

  MyTextField rg = MyTextField(
    text: 'RG',
    listInputFormat: [
      FilteringTextInputFormatter.digitsOnly,
    ],
    listValidator: [Validatorless.required('Campo obrigatório!')],
  );

  MyTextField phone = MyTextField(
    text: 'Telefone',
    listInputFormat: [
      FilteringTextInputFormatter.digitsOnly,
    ],
    listValidator: [Validatorless.required('Campo obrigatório!')],
  );

  MyTextField job = MyTextField(
    text: 'Profissão',
    listValidator: [Validatorless.required('Campo obrigatório!')],
    listInputFormat: const [],
  );

  MyTextField email = MyTextField(
    text: 'Email',
    listValidator: [
      Validatorless.required('Campo obrigatório!'),
      Validatorless.email('Email inválido!')
    ],
    listInputFormat: const [],
  );
}

// Consumer<XProvider>(
//  builder: (context, xProvider, child) {
//    return Text(xProvider.text,
//      style: const TextStyle(
//        fontSize: 16));
//}),