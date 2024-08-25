import 'package:validatorless/validatorless.dart';

class CustomValidator implements Validatorless {
  static String? standartPasswordValidator(String? value) {
    if (value == '123456') {
      return 'Senha não pode ser igual a 123456';
    }
    return null;
  }
}
