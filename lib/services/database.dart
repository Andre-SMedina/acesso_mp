import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:acesso_mp/models/model_visitors.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/services/db_manage.dart';
import 'package:flutter/material.dart';

class Database {
  final Function alertVisited;
  Database({required this.alertVisited});

  Future<String> register(
      ModelVisitors data, String type, BuildContext context) async {
    var check = MyFunctons.getHive('visitor');
    Map<dynamic, dynamic> dataMap = Convert.forMap(data);

    if (type == 'save' && check == '') {
      String msg = '';
      List<String> visited = await alertVisited();

      // ignore: use_build_context_synchronously
      await DbManage.save(data, visited).then((e) {
        if (!e) {
          msg = 'cpfExist';
        } else {
          msg = 'saved';
        }
      });

      return msg;
    }
    if (type == 'update' && check != '') {
      DbManage.update(
          data: dataMap,
          column: 'cpf',
          find: check['cpf'],
          table: 'visitors',
          boxName: 'visitor');

      return 'updated';
    }

    return 'exist';
  }
}
