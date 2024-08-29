import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyFunctons {
  static var box = Hive.box('db');
  static SupabaseClient supabase = Supabase.instance.client;

  static Future<List> getOperators() async {
    List operators =
        await supabase.from('operators').select('id, name, locations(name)');

    return operators;
  }

  static Future<List> getLocations() async {
    List locations = await supabase
        .from('locations')
        .select()
        .order('name', ascending: true);

    return locations;
  }

  static Future<List> getVisits(int locationId) async {
    List visits = await supabase
        .from('visits')
        .select(
            'goal, date, authorizedBy, locations(name), operators(name), visitors(name)')
        .eq(
          'id_location',
          locationId,
        );
    print(visits);

    return visits;
  }

  static getHive(String nameBox, {bool names = false}) {
    if (names) {
      List<String> locationsName = [];
      for (var i in box.get(nameBox)) {
        locationsName.add(i['name']);
      }
      return locationsName;
    }
    return box.get(nameBox);
  }

  static putHive(String nameBox, data) {
    return box.put(nameBox, data);
  }
}
