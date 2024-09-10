import 'package:acesso_mp/helpers/std_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MyDropdown extends StatefulWidget {
  MyDropdown(
      {super.key,
      required this.optionsList,
      required this.getItemSelected,
      required this.labelText,
      this.searchController});
  final String labelText;
  TextEditingController? searchController;
  final List optionsList;
  final ValueChanged<String> getItemSelected;
  @override
  MyDropdownState createState() => MyDropdownState();
}

class MyDropdownState extends State<MyDropdown> {
  // TextEditingController searchController = TextEditingController();
  List<String> filterList = [];
  List<String> visitedList = [];

  List<dynamic> _getSuggestions(String query) {
    // if (query.length < 3) {
    //   return [];
    // }

    List<dynamic> filterList = widget.optionsList
        .where((e) => e.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return filterList;
  }

  void foundVisitor(String suggestion) async {
    var visitor = widget.optionsList.where((e) {
      return e.toLowerCase() == suggestion.toLowerCase();
    }).toList()[0];

    widget.searchController!.text = visitor;
    widget.getItemSelected(visitor);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 25),
      // ignore: avoid_types_as_parameter_names
      child: TypeAheadField(
        constraints: const BoxConstraints(maxHeight: 200),
        controller: widget.searchController,
        emptyBuilder: (context) => const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Nenhum resultado encontrado'),
        ),
        builder: (context, controller, focusNode) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.search,
                  size: 30,
                  color: StdValues.labelGrey,
                ),
                filled: true,
                fillColor: Colors.white,
                hoverColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: StdValues.borderFieldGrey)),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 105, 105, 105),
                  ),
                ),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                labelText: widget.labelText),
          );
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            tileColor: Colors.white,
            mouseCursor: MouseCursor.defer,
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
