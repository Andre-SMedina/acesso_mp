import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ManageData {
  static void authorized(BuildContext context) async {
    var box = Hive.box('db');
    var checked = box.get('visitor');

    if (checked != null && checked != '') {
      String visited = '';
      await ZshowDialogs.visited(context).then((v) => visited = v);

      String dateNow = DateFormat('dd/MM/yyy HH:mm:ss').format(DateTime.now());

      checked['visit'].add('$dateNow $visited');

      box.put(Convert.removeAccent(checked['name'].toLowerCase()), checked);

      ZshowDialogs.alert(context, 'Autorização registrada!');
    }
  }
}
