import 'package:acesso_mp/models/model_visitors.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/services/db_manage.dart';

class Database {
  final Function alertVisited;
  Database({required this.alertVisited});

  Future<String> register(ModelVisitors data, String type) async {
    // Map visitor = {
    //   'name': data.name.toLowerCase(),
    //   'cpf': data.cpf,
    //   'rg': data.rg,
    //   'phone': data.phone,
    //   'job': data.job,
    //   'image': data.image,
    // };

    List<Map> check = [];
    await DbManage.get(Convert.removeAccent(data.name).toLowerCase()).then((e) {
      check = e;
    });

    if (type == 'save' && check.isEmpty) {
      String visited = await alertVisited();

      if (visited == '') return 'empty';

      await DbManage.save(data, visited);

      return 'saved';
    }
    if (type == 'update' && check.isNotEmpty) {
      if (check.length > 1) {
        for (var v in check) {
          if (data.cpf == v['cpf']) {
            print(v);
            await DbManage.update(data);
            return 'update';
          }
        }
      }

      // print('ok');

      DbManage.update(data);

      return 'updated';
    }

    return 'exist';
  }
}
