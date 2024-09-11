import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbVisits {
  final Function alertVisited;
  final Function alert;
  DbVisits({required this.alert, required this.alertVisited});

  Future<bool> authorized(BuildContext context) async {
    var checked = MyFunctons.getHive('visitor');

    if (checked != null && checked != '') {
      List<String> auth = await alertVisited();

      if (auth[0].isEmpty || auth[1].isEmpty) {
        return false;
      }

      String dateNow = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
      String date = dateNow.split(' ')[0];
      String time = dateNow.split(' ')[1];

      SupabaseClient supabase = Supabase.instance.client;
      Map profile = MyFunctons.getHive('profile');

      await supabase.from('visits').insert({
        'goal': auth[0],
        'authorizedBy': auth[1],
        'sector': auth[2],
        'date': date,
        'time': time,
        'id_visitor': checked['id'],
        'id_location': profile['locations']['id'],
        'id_operator': profile['id']
      });

      alert();

      return true;
    }
    return false;
  }
}
