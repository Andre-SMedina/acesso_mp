import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/services/x_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

// ignore: must_be_immutable
class MyHomeFormfield extends StatelessWidget {
  MyHomeFormfield({
    super.key,
    required this.labelTitle,
    this.listInputFormat,
    required this.listValidator,
    this.icon,
    this.labelText,
  });
  final String labelTitle;
  final String? labelText;
  final Icon? icon;
  final List<TextInputFormatter>? listInputFormat;
  final List<FormFieldValidator<String>> listValidator;

  TextEditingController fieldController = TextEditingController();
  bool enableField = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<XProvider>(builder: (context, provider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelTitle,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: StdValues.labelGrey),
          ),
          SizedBox(
            height: 65,
            child: TextFormField(
              controller: fieldController,
              inputFormatters: listInputFormat,
              validator: Validatorless.multiple(listValidator),
              decoration: InputDecoration(
                  hintText: labelText,
                  prefixIcon: icon,
                  contentPadding: const EdgeInsets.only(left: 8),
                  enabled: (labelTitle == 'RG') ? provider.enableField : true,
                  filled: true,
                  helperText: '',
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: StdValues.borderFieldGrey)),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 105, 105, 105)))),
            ),
          ),
        ],
      );
    });
  }
}
