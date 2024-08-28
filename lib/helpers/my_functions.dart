import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyFunctons {
  static var box = Hive.box('db');

  static Future<List> getOperators() async {
    SupabaseClient supabase = Supabase.instance.client;
    List operators =
        await supabase.from('operators').select('id, name, locations(name)');

    return operators;
  }

  static Future<List> getLocations() async {
    SupabaseClient supabase = Supabase.instance.client;
    var locations = await supabase.from('locations').select();
    return locations;
  }

  static getHive(String nameBox) {
    return box.get(nameBox);
  }

  static putHive(String nameBox, data) {
    return box.put(nameBox, data);
  }
}
