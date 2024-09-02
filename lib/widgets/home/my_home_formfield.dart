import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validatorless/validatorless.dart';

// ignore: must_be_immutable
class MyHomeFormfield extends StatelessWidget {
  final String labelText;
  final List<TextInputFormatter>? listInputFormat;
  final List<FormFieldValidator<String>> listValidator;
  MyHomeFormfield({
    super.key,
    required this.labelText,
    this.listInputFormat,
    required this.listValidator,
  });

  TextEditingController fieldController = TextEditingController();
  bool enableField = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 105, 105, 105)),
        ),
        TextFormField(
          controller: fieldController,
          inputFormatters: listInputFormat,
          validator: Validatorless.multiple(listValidator),
          decoration: InputDecoration(
              enabled: enableField,
              filled: true,
              helperText: '',
              fillColor: Colors.white,
              border: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 105, 105, 105)))),
        ),
      ],
    );
  }
}
