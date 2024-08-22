import 'package:acesso_mp/models/model_visitors.dart';
import 'package:flutter/material.dart';

class Convert {
  static List<ModelVisitors> forModel(List<String> list) {
    List<ModelVisitors> listVisitors = [];

    for (String entry in list) {
      List<String> listSplit = entry.split(',');

      listVisitors.add(ModelVisitors(
          name: listSplit[0],
          cpf: listSplit[1],
          rg: listSplit[2],
          phone: listSplit[3],
          job: listSplit[4],
          image: listSplit[5]));
    }

    return listVisitors;
  }

  static Map<dynamic, dynamic> forMap(ModelVisitors data) {
    Map<dynamic, dynamic> map = {
      'name': data.name,
      'consult': removeAccent(data.name).toLowerCase(),
      'cpf': data.cpf,
      'rg': data.rg,
      'phone': data.phone,
      'job': data.job,
      'image': data.image
    };

    return map;
  }

  static String firstUpper(String name) {
    List<String> listName = name.split(' ');
    List<String> newListName = [];
    for (String slice in listName) {
      newListName.add('${slice[0].toUpperCase()}${slice.substring(1)}');
    }

    return newListName.join(' ');
  }

  static String removeAccent(String data) {
    const String withAccents = 'áàâãäéèêëíìîïóòôõöúùûüçÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇ';
    const String withoutAccents =
        'aaaaaeeeeiiiiooooouuuucAAAAAEEEEIIIIOOOOOUUUUC';
    String name = data.split(',')[0];

    return name.characters.map((char) {
      final index = withAccents.indexOf(char);
      return index == -1 ? char : withoutAccents[index];
    }).join();
  }

  static List<String> forList(List<Map> listMap, String key) {
    List<String> list = listMap.map((map) {
      String item = Convert.removeAccent(map[key].toLowerCase());
      String itemModify = "${item.split(' ').first}${item.split(' ').last}";

      return itemModify;
    }).toList();

    return list;
  }
}
