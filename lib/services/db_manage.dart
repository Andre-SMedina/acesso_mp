import 'package:acesso_mp/models/model_visitors.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbManage {
  static final supabase = Supabase.instance.client;

  static save(ModelVisitors data, String goal) async {
    String dateNow = DateFormat('dd/MM/yyy HH:mm:ss').format(DateTime.now());

    await supabase.from('visitors').insert({
      'name': data.name,
      'consult': Convert.removeAccent(data.name).toLowerCase(),
      'cpf': data.cpf,
      'rg': data.rg,
      'phone': data.phone,
      'job': data.job,
      'image': data.image
    });

    var visitor = await supabase.from('visitors').select().eq('cpf', data.cpf);

    await supabase.from('visits').insert(
        {'goal': goal, 'date': dateNow, 'id_visitor': visitor[0]['id']});
  }

  static Future<dynamic> get(String name) async {
    List<Map> visitors = await supabase
        .from('visitors')
        .select('*, visits(*)')
        .ilike('consult', '%$name%');
    // await supabase.from('visitors').select().ilike('consult', '%$name%');

    // List<Map> visits = [];

    // for (var v in response) {
    //   var visit =
    //       await supabase.from('visits').select().eq('id_visitor', v['id']);

    //   for (var e in visit) {
    //     visits.add(e);
    //   }
    // }

    // print(response);

    // var visitors = response.map((e) async {
    //   var listVisits =
    //       await supabase.from('visits').select().eq('id_visitor', e['id']).th;
    // visitor['visit'] = ['$dateNow|$visited'];

    //   for (var v in listVisits) {
    //     print(v);
    //     visits.add('${v['date']}|${v['goal']}');
    //   }
    //   e['visits'] = visits;

    //   return e;
    // });

    // print(visitors);

    return visitors;
  }
}
