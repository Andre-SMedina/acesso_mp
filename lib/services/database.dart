import 'package:acesso_mp/models/model_visitors.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/services/db_manage.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class Database {
  final Function alertVisited;
  Database({required this.alertVisited});

  Future<String> register(ModelVisitors data, String type) async {
    Box<dynamic> box = Hive.box('db');
    Map visitor = {
      'name': data.name.toLowerCase(),
      'cpf': data.cpf,
      'rg': data.rg,
      'phone': data.phone,
      'job': data.job,
      'image': data.image,
    };
    // DocumentReference doc =
    // FirebaseFirestore.instance.collection('teste').doc('mydoc');

    var check =
        box.get(Convert.removeAccent(data.name).toLowerCase()) ?? 'notFound';

    if (type == 'save' && check == 'notFound') {
      String visited = await alertVisited();

      if (visited == '') return 'empty';

      String dateNow = DateFormat('dd/MM/yyy HH:mm:ss').format(DateTime.now());
      visitor['visit'] = ['$dateNow|$visited'];

      String name = Convert.removeAccent(data.name.toLowerCase());

      box.put(name, visitor);
      // await doc.update({name: visitor});
      DbManage.save(data, visited);

      return 'saved';
    }
    if (type == 'update' && check != 'notFound') {
      visitor['visit'] = check['visit'];
      String name = Convert.removeAccent(data.name.toLowerCase());
      box.put(name, visitor);
      // await doc.update({name: visitor});

      return 'updated';
    }

    return 'exist';
  }
}
