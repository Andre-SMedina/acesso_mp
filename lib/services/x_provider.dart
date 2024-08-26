import 'package:acesso_mp/widgets/my_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:hive/hive.dart';
import 'package:validatorless/validatorless.dart';

class XProvider with ChangeNotifier {
  bool enableField = true;
  String? errorText;
  TextEditingController locateController = TextEditingController();
  MaskedTextController cpfController = MaskedTextController(
    mask: '000.000.000-00',
  );
  MaskedTextController phoneController = MaskedTextController(
    mask: '(00) 0 0000-0000',
  );
  bool validate = true;
  bool get enableField2 => enableField;
  String? get errorText2 => errorText;
  TextEditingController get locateCotroller2 => locateController;
  MaskedTextController get cpfController2 => cpfController;
  bool get validate2 => validate;
  MyTextField get name2 => name;

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
    cpfController.text = "${visitor['cpf'].substring(0, 5)}...";
    rg.fieldController.text = visitor['rg'];
    phoneController.text = visitor['phone'];
    job.fieldController.text = visitor['job'];
    enableField = false;
    rg.enableField = false;
    validate = false;
    notifyListeners();
  }

  void clearFields() {
    name.fieldController.text = '';
    cpfController.text = '';
    rg.fieldController.text = '';
    phoneController.text = '';
    job.fieldController.text = '';
    email.fieldController.text = '';
    locateController.text = '';
    enableField = true;
    rg.enableField = true;
    validate = true;
    var box = Hive.box('db');
    box.putAll({'visitor': '', 'image': ''});
    notifyListeners();
  }

  void loadOperatorField(Map operator) {
    locateController.text = operator['locations']['name'];
    name.fieldController.text = operator['name'];
    cpfController.text = operator['cpf'].toString();
    phoneController.text = operator['phone'].toString();
    email.fieldController.text = operator['email'];
    enableField = false;

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

  TextFormField cpfWidget() {
    return TextFormField(
      controller: cpfController,
      decoration: const InputDecoration(
        labelText: 'CPF',
        filled: true,
        fillColor: Colors.white,
        helperText: '',
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11)
      ],
      validator: (validate)
          ? Validatorless.multiple([
              Validatorless.cpf('CPF inválido!'),
              Validatorless.required('Campo obrigatório!')
            ])
          : null,
      enabled: enableField,
    );
  }

  MyTextField rg = MyTextField(
    text: 'RG',
    listInputFormat: [
      FilteringTextInputFormatter.digitsOnly,
    ],
    listValidator: [Validatorless.required('Campo obrigatório!')],
  );

  TextFormField phoneWidget() {
    return TextFormField(
      controller: phoneController,
      decoration: const InputDecoration(
        labelText: 'Telefone',
        filled: true,
        fillColor: Colors.white,
        helperText: '',
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: Validatorless.required('Campo obrigatório!'),
    );
  }

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