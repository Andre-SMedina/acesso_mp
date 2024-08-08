import 'package:acesso_mp/helpers/search_db.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/services/db_manage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

    List<String> listDropdown = [];
    await DbManage.get(query).then((e) {
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
      padding: const EdgeInsets.all(16.0),
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
            autofocus: true,
            decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                border: OutlineInputBorder(),
                labelText: 'Pesquisar'),
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
