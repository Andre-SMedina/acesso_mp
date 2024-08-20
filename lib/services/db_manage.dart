import 'package:acesso_mp/models/model_visitors.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
      response = false;
    }

    if (response) {
      //pega o registro atual no banco para ter acesso ao id e criar a foreing key
      var visitor =
          await supabase.from('visitors').select().eq('cpf', data.cpf);

      await supabase.from('visits').insert(
          {'goal': goal, 'date': dateNow, 'id_visitor': visitor[0]['id']});
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

      await supabase.from('operators').insert(operator);
      response = true;
    } catch (err) {
      debugPrint(err.toString());
    }

    return response;
  }

  static Future<List> getOperators() async {
    var operators = await supabase.from('operators').select('*, locations(*)');

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

  static Future<dynamic> getLocations() async {
    List<Map> locations = [];
    try {
      locations = await supabase
          .from('locations')
          .select()
          .order('name', ascending: true);
    } catch (err) {
      debugPrint(err.toString());
    }

    return locations;
  }

  static deleteLocate(String locate) async {
    try {
      await supabase.from('locations').delete().eq('name', locate);
    } catch (err) {
      debugPrint(err.toString());
    }
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
      {required Map<dynamic, dynamic> data,
      required String table,
      required String column,
      required String find}) async {
    var box = Hive.box('db');
    Map visitor = box.get('visitor');
    data['cpf'] = visitor['cpf'];
    data['rg'] = visitor['rg'];
    // await supabase.from(table).select().eq(column, find).then((e) {
    // print(e);
    // });

    await supabase.from(table).update(data).eq(column, find);
  }
}
