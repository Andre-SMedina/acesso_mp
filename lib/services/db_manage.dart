import 'package:acesso_mp/models/model_visitors.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbManage {
  static final SupabaseClient supabase = Supabase.instance.client;

  static Future<bool> save(ModelVisitors data, String goal) async {
    String dateNow = DateFormat('dd/MM/yyy HH:mm:ss').format(DateTime.now());
    bool response = false;

    try {
      await supabase.from('visitors').insert({
        'name': data.name,
        'consult': Convert.removeAccent(data.name).toLowerCase(),
        'cpf': data.cpf,
        'rg': data.rg,
        'phone': data.phone,
        'job': data.job,
        'image': data.image
      });

      response = true;
    } catch (err) {
      print(err);
      response = false;
    }

    if (response) {
      //pega o registro atual no banco para ter acesso ao id e criar a foreng key
      var visitor =
          await supabase.from('visitors').select().eq('cpf', data.cpf);

      await supabase.from('visits').insert(
          {'goal': goal, 'date': dateNow, 'id_visitor': visitor[0]['id']});
    }

    return response;
  }

  static Future<dynamic> get(String name) async {
    List<Map> visitors = await supabase
        .from('visitors')
        .select('*, visits(*)')
        .ilike('consult', '%$name%');

    return visitors;
  }

  static update(ModelVisitors data) async {
    await supabase.from('visitors').update({
      'name': data.name,
      'consult': Convert.removeAccent(data.name).toLowerCase(),
      'cpf': data.cpf,
      'rg': data.rg,
      'phone': data.phone,
      'job': data.job,
      'image': data.image
    }).eq('cpf', data.cpf);
  }
}
