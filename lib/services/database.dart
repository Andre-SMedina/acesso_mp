import 'package:acesso_mp/models/model_visitors.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/services/db_manage.dart';
import 'package:hive/hive.dart';

class Database {
  final Function alertVisited;
  Database({required this.alertVisited});

  Future<String> register(ModelVisitors data, String type) async {
    var box = Hive.box('db');
    var check = box.get('visitor');
    Map<dynamic, dynamic> dataMap = Convert.forMap(data);

    if (type == 'save' && check == '') {
      String msg = '';
      String visited = await alertVisited();

      if (visited == '') return 'empty';

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
