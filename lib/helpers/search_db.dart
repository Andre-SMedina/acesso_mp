import 'package:acesso_mp/services/convert.dart';
import 'package:hive/hive.dart';

List<dynamic> searchDb(String partialKey) {
  var box = Hive.box('db');
  String formatKey = Convert.removeAccent(partialKey).toLowerCase();

  List<dynamic> keys = box.keys.where((key) {
    return key.toString().contains(formatKey);
  }).toList();

  return keys;
}
