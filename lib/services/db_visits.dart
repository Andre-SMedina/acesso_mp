import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbVisits {
  final Function alertVisited;
  final Function alert;
  DbVisits({required this.alert, required this.alertVisited});

  Future<bool> authorized() async {
    var box = Hive.box('db');
    var checked = box.get('visitor');

    if (checked != null && checked != '') {
      var auth = await alertVisited();

      String dateNow = DateFormat('dd/MM/yyy HH:mm:ss').format(DateTime.now());

      SupabaseClient supabase = Supabase.instance.client;
      Map profile = MyFunctons.getHive('profile');

      print(profile);

      // await supabase.from('visits').insert({
      //   'goal': auth[0],
      //   'authorizedBy': auth[1],
      //   'date': dateNow,
      //   'id_visitor': checked['id'],
      //   'location': profile['locations']['name'],
      //   'id_operator': profile['id']
      // });

      alert();

      return true;
    }
    return false;
  }
}
