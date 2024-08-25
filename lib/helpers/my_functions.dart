import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyFunctons {
  static var box = Hive.box('db');

  static Future<List> getOperators() async {
    SupabaseClient supabase = Supabase.instance.client;
    List operators = await supabase.from('operators').select('id, name');
    List newOperators = operators.map((e) {
      List list = e['name'].split(' ');
      String firstName = list.first;
      String lastName = list.last;
      e['name'] = "$firstName $lastName";
      return e;
    }).toList();

    return newOperators;
  }

  static getHive(String nameBox) {
    return box.get(nameBox);
  }

  static putHive(String nameBox, data) {
    return box.put(nameBox, data);
  }
}
