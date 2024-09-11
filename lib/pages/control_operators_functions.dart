// ignore_for_file: use_build_context_synchronously

import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/services/db_manage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ControlOperatorsFunctions {
  static update({
    required BuildContext context,
    required Function reload,
    required Map<String, String> data,
    required String location,
  }) async {
    bool validate = false;

    SupabaseClient supabase = Supabase.instance.client;
    List cpfs = await supabase.from('operators').select('cpf');
    validate = false;

    for (var item in cpfs) {
      if (item['cpf'] == data['cpf']) {
        await ZshowDialogs.confirm(context, 'Salvar alterações?').then((e) {
          validate = e;
        });
      }
    }

    if (validate) {
      List locationsId = MyFunctons.getHive('locationsFull');

      int locationId = 0;
      for (var e in locationsId) {
        if (e['name'] == location) {
          locationId = e['id'];
        }
      }

      Map operator = {
        'name': Convert.firstUpper(data['name']!),
        'cpf': data['cpf'],
        'phone': data['phone'],
        'email': data['email'],
        'location': locationId
      };

      DbManage.update(
        data: operator,
        table: 'operators',
        column: 'cpf',
        find: operator['cpf'],
        boxName: 'operator',
      );

      ZshowDialogs.alert(context, 'Usuário atualizado!');
      reload();
    } else {
      ZshowDialogs.alert(context, 'Operador não encontrado!');
    }
  }
}
