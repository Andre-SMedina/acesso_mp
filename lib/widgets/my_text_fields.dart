import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validatorless/validatorless.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  final String text;
  final List<FormFieldValidator<String>> listValidator;
  final List<TextInputFormatter> listInputFormat;
  bool enableField = true;
  MyTextField({
    super.key,
    required this.text,
    required this.listValidator,
    required this.listInputFormat,
  });

  final TextEditingController fieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: TextFormField(
        validator: Validatorless.multiple(listValidator),
        controller: fieldController,
        inputFormatters: listInputFormat,
        decoration: InputDecoration(
          hintText: 'testando',
          enabled: enableField,
          filled: true,
          fillColor: Colors.white,
          labelText: text,
          helperText: '',
        ),
      ),
    );
  }

  void loadData(String text) {
    fieldController.text = text;
  }

  void clearData() {
    fieldController.clear();
  }
}
