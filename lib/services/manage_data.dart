import 'package:acesso_mp/services/convert.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ManageData {
  final Function alertVisited;
  final Function alert;
  ManageData({required this.alert, required this.alertVisited});

  void authorized() async {
    var box = Hive.box('db');
    var checked = box.get('visitor');

    if (checked != null && checked != '') {
      var visited = await alertVisited();

      String dateNow = DateFormat('dd/MM/yyy HH:mm:ss').format(DateTime.now());

      checked['visit'].add('$dateNow $visited');

      box.put(Convert.removeAccent(checked['name'].toLowerCase()), checked);

      alert();
    }
  }
}
