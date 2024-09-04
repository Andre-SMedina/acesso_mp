import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/widgets/home/my_home_formfield.dart';
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
  bool passwd = true;
  Icon passwdIcon = const Icon(
    Icons.visibility_off_outlined,
    color: Color.fromARGB(255, 116, 116, 116),
    size: 27,
  );
  bool get enableField2 => enableField;
  String? get errorText2 => errorText;
  TextEditingController get locateCotroller2 => locateController;
  MaskedTextController get cpfController2 => cpfController;
  bool get validate2 => validate;
  bool get passwd2 => passwd;
  MyHomeFormfield get name2 => name;
  Icon get passwdIcon2 => passwdIcon;

  void changeText() {
    errorText = 'Digite o nome da lotação para pesquisar, e escolha uma!';
    notifyListeners();
  }

  void cleanText() {
    errorText = null;
    notifyListeners();
  }

  void passwdChange() {
    passwd = !passwd;
    notifyListeners();
  }

  void passwdIconChange() {
    if (!passwd) {
      passwdIcon = const Icon(
        Icons.visibility_outlined,
        color: Color.fromARGB(255, 116, 116, 116),
        size: 27,
      );
    } else {
      passwdIcon = const Icon(
        Icons.visibility_off_outlined,
        color: Color.fromARGB(255, 116, 116, 116),
        size: 27,
      );
    }
    notifyListeners();
  }

  void loadVisitorsField(Map<String, dynamic> visitor) {
    name.fieldController.text = visitor['name'];
    cpfController.text = "${visitor['cpf'].substring(0, 5)}...";
    rg.fieldController.text = visitor['rg'];
    phoneController.text = visitor['phone'];
    job.fieldController.text = visitor['job'];
    enableField = false;
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

  MyHomeFormfield name = MyHomeFormfield(
    labelText: '  Nome do visitante',
    listValidator: [
      Validatorless.required('Campo obrigatório!'),
      (v) => v!.split(' ').length >= 2
          ? null
          : 'O nome deve ter nome e sobrenome!',
    ],
  );

  // MyTextField name = MyTextField(
  //   text: 'Nome',
  //   listInputFormat: const [],
  //   listValidator: [
  //     Validatorless.required('Campo obrigatório!'),
  //TODO: se colocar um nome e um espaço na hora de cadastrar o nome, dá erro
  //     (v) => v!.split(' ').length >= 2
  //         ? null
  //         : 'O nome deve ter nome e sobrenome!',
  //   ],
  // );

  Widget cpfWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '  CPF',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 105, 105, 105)),
        ),
        SizedBox(
          height: 65,
          child: TextFormField(
            controller: cpfController,
            decoration: InputDecoration(
                filled: true,
                contentPadding: const EdgeInsets.only(left: 8),
                fillColor: Colors.white,
                helperText: '',
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: StdValues.borderFieldGrey)),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 105, 105, 105)))),
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
          ),
        ),
      ],
    );
  }

  MyHomeFormfield rg = MyHomeFormfield(
    labelText: '  RG',
    listInputFormat: [
      FilteringTextInputFormatter.digitsOnly,
    ],
    listValidator: [Validatorless.required('Campo obrigatório!')],
  );
  // MyTextField rg = MyTextField(
  //   text: 'RG',
  //   listInputFormat: [
  //     FilteringTextInputFormatter.digitsOnly,
  //   ],
  //   listValidator: [Validatorless.required('Campo obrigatório!')],
  // );

  Widget phoneWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '  Telefone',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 105, 105, 105)),
        ),
        SizedBox(
          height: 65,
          child: TextFormField(
            controller: phoneController,
            decoration: InputDecoration(
                filled: true,
                contentPadding: const EdgeInsets.only(left: 8),
                fillColor: Colors.white,
                helperText: '',
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: StdValues.borderFieldGrey)),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 105, 105, 105)))),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: Validatorless.required('Campo obrigatório!'),
          ),
        ),
      ],
    );
  }

  MyHomeFormfield job = MyHomeFormfield(
    labelText: '  Profissão',
    listValidator: [Validatorless.required('Campo obrigatório!')],
  );

  // MyTextField job = MyTextField(
  //   text: 'Profissão',
  //   listValidator: [Validatorless.required('Campo obrigatório!')],
  //   listInputFormat: const [],
  // );

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
//  builder: (context, provider, child) {
//    return Text(xProvider.text,
//      style: const TextStyle(
//        fontSize: 16));
//}),