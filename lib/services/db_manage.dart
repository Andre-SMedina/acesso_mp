import 'package:acesso_mp/models/model_visitors.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbManage {
  static final SupabaseClient supabase = Supabase.instance.client;

  static Future<bool> save(ModelVisitors data, List<String> auth) async {
    var box = Hive.box('db');
    Map profile = box.get('profile');

    if (profile['name'] == 'adm') return true;

    String dateNow = DateFormat('dd/MM/yyy HH:mm:ss').format(DateTime.now());
    String date = dateNow.split(' ')[0];
    String time = dateNow.split(' ')[1];
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
      response = false;
    }

    if (response) {
      //pega o registro atual no banco para ter acesso ao id e criar a foreing key
      var visitor =
          await supabase.from('visitors').select().eq('cpf', data.cpf);

      await supabase.from('visits').insert({
        'goal': auth[0],
        'authorizedBy': auth[1],
        'date': date,
        'time': time,
        'id_visitor': visitor[0]['id'],
        'id_location': profile['locations']['id'],
        'id_operator': profile['id']
      });
    }

    return response;
  }

  static Future<bool> saveOperator(Map dataOperator, String locate) async {
    bool response = false;
    try {
      List getLocate =
          await supabase.from('locations').select().eq('name', locate);
      int locateId = getLocate[0]['id'];

      Map operator = dataOperator;
      operator['location'] = locateId.toString();
      operator['userName'] = Convert.forUserName(operator['name']);
      operator['name'] = Convert.firstUpper(operator['name']);

      await supabase.from('operators').insert(operator);
      response = true;
    } catch (err) {
      debugPrint(err.toString());
    }

    return response;
  }

  static Future<List> getOperators() async {
    var operators = await supabase
        .from('operators')
        .select('*, locations(*)')
        .order('name', ascending: true);

    return operators;
  }

  static Future<bool> saveLocate(String locate) async {
    bool response = false;

    try {
      await supabase.from('locations').insert({'name': locate});
      response = true;
    } catch (err) {
      debugPrint(err.toString());
    }

    return response;
  }

  static Future<dynamic> getJoin(
      {required String findTb1,
      required String columnTb1,
      required String table1,
      required String table2}) async {
    List<Map> response = await supabase
        .from(table1)
        .select('*, $table2(*)')
        .ilike(columnTb1, '%$findTb1%');

    return response;
  }

  static update(
      {required var data,
      required String table,
      required String column,
      required String find,
      required String boxName}) async {
    var box = Hive.box('db');

    if (boxName != '') {
      var oldData = box.get(boxName);

      data['cpf'] = oldData['cpf'];
      if (data['rg'] != null) data['rg'] = oldData['rg'];
    }
    try {
      await supabase.from(table).update(data).eq(column, find);
    } catch (err) {
      debugPrint(err.toString());
    }
  }
}
