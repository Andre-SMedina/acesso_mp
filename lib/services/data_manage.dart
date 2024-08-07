import 'package:acesso_mp/services/convert.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ManageData {
  final Function alertVisited;
  final Function alert;
  ManageData({required this.alert, required this.alertVisited});

  Future<bool> authorized() async {
    var box = Hive.box('db');
    var checked = box.get('visitor');

    if (checked != null && checked != '') {
      var visited = await alertVisited();

      if (visited != '') {
        // DocumentReference doc =
        //     FirebaseFirestore.instance.collection('teste').doc('mydoc');
        String dateNow =
            DateFormat('dd/MM/yyy HH:mm:ss').format(DateTime.now());

        checked['visit'].add('$dateNow|$visited');

        String name = Convert.removeAccent(checked['name'].toLowerCase());

        box.put(name, checked);
        // await doc.update({name: checked});

        alert();

        return true;
      }
    }
    return false;
  }
}
