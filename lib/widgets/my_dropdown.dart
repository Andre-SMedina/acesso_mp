import 'package:acesso_mp/helpers/search_db.dart';
import 'package:acesso_mp/services/convert.dart';
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

  Future<List<dynamic>> _getSuggestions(String query) async {
    if (query.length < 3) {
      return [];
    }

    var box = Hive.box('db');

    List<String> listDropdown = [];
    List<dynamic> items = searchDb(query);
    for (var name in items) {
      var dataVisitor = box.get(name);
      listDropdown.add(Convert.firstUpper(dataVisitor['name']));
    }

    return listDropdown;
  }

  void foundVisitor(String suggestion) async {
    var box = Hive.box('db');
    var dataVisitor = box.get(Convert.removeAccent(suggestion).toLowerCase());
    await box.put('visitor', dataVisitor);
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
                border: OutlineInputBorder(), labelText: 'Pesquisar'),
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
