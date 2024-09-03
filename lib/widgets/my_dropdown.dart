import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/services/db_manage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive/hive.dart';

class MyDropdown extends StatefulWidget {
  final VoidCallback loadData;
  const MyDropdown({
    super.key,
    required this.loadData,
  });

  @override
  MyDropdownState createState() => MyDropdownState();
}

class MyDropdownState extends State<MyDropdown> {
  TextEditingController searchController = TextEditingController();
  List<String> filterList = [];
  List<String> visitedList = [];
  List listVisitor = [];

  Future<List<dynamic>> _getSuggestions(String query) async {
    if (query.length < 3) {
      return [];
    }
    listVisitor = [];

    List<String> listDropdown = [];
    await DbManage.getJoin(
            table1: 'visitors',
            table2: 'visits',
            columnTb1: 'consult',
            findTb1: query)
        .then((e) {
      for (var v in e) {
        listDropdown.add(Convert.firstUpper(v['name']));
        listVisitor.add(v);
      }
    });

    return listDropdown;
  }

  void foundVisitor(String suggestion) async {
    var box = Hive.box('db');
    var visitor = listVisitor.where((e) {
      return e['name'].toLowerCase() == suggestion.toLowerCase();
    }).toList()[0];

    await box.put('visitor', visitor);
    searchController.text = '';
    widget.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 25),
      child: TypeAheadField(
        controller: searchController,
        emptyBuilder: (context) => const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Nenhum resultado encontrado'),
        ),
        builder: (context, controller, focusNode) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.search,
                  size: 30,
                  color: Color.fromARGB(255, 105, 105, 105),
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 105, 105, 105),
                  ),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                labelText: 'Digite o nome do visitante'),
          );
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        suggestionsCallback: (search) {
          return _getSuggestions(search);
        },
        onSelected: (suggestion) {
          foundVisitor(suggestion);
        },
      ),
    );
  }
}
