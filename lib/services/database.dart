import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/models/model_visitors.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class Database {
  Future<String> register(
      ModelVisitors data, BuildContext context, String type) async {
    Box<dynamic> box = Hive.box('db');
    Map visitor = {
      'name': data.name.toLowerCase(),
      'cpf': data.cpf,
      'rg': data.rg,
      'phone': data.phone,
      'job': data.job,
      'image': data.image,
    };

    var check =
        box.get(Convert.removeAccent(data.name).toLowerCase()) ?? 'notFound';

    if (type == 'save' && check == 'notFound') {
      String visited = '';
      await ZshowDialogs.visited(context).then((v) => visited = v);

      String dateNow = DateFormat('dd/MM/yyy HH:mm:ss').format(DateTime.now());
      visitor['visit'] = ['$dateNow $visited'];

      box.put(Convert.removeAccent(data.name.toLowerCase()), visitor);

      return 'saved';
    }
    if (type == 'update' && check != 'notFound') {
      visitor['visit'] = check['visit'];
      box.put(Convert.removeAccent(data.name.toLowerCase()), visitor);
      return 'updated';
    }

    return 'exist';
  }
}
