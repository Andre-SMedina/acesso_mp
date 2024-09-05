import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/widgets/home/my_home_container.dart';
import 'package:acesso_mp/widgets/home/my_home_formfield.dart';
import 'package:acesso_mp/widgets/my_button.dart';
import 'package:acesso_mp/widgets/my_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive/hive.dart';

class HistoryPage2 extends StatefulWidget {
  const HistoryPage2({super.key});

  @override
  State<HistoryPage2> createState() => _HistoryPage2State();
}

class _HistoryPage2State extends State<HistoryPage2> {
  TextStyle title = const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

  var profile = MyFunctons.getHive('profile');

  List locationsName = [];

  int locationId = 0;

  TextEditingController dropController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  var box = Hive.box('db');

  void loadLocation(String locationName) {
    List locations = MyFunctons.getHive('locations');
    for (var location in locations) {
      if (location['name'] == locationName) {
        locationId = location['id'];
      }
      setState(() {});
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      String date = Convert.formatDate(picked.toString().split(' ')[0]);
      dateController.text = date;
    }
  }

  Widget tableText(String text,
      {double? size, bool? bold = false, bool color = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: bold! ? FontWeight.bold : FontWeight.normal,
              fontSize: (size != null) ? size : 16,
              color: (color) ? Colors.black : Colors.white)),
    );
  }

  List<TableRow> buildTableRows() {
    return List.generate(
      30, // Substitua com o tamanho da sua lista de dados
      (index) => TableRow(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: index % 2 == 0 ? StdValues.bkgFieldGrey : Colors.white,
        ),
        children: [
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: tableText('Maria de Jesus Carvalho')),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: tableText('Pedro Alvarre Cabal')),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: tableText('22/07/2024')),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: tableText('22:50')),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: tableText('Ana Beatri Melo de Sousa ')),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: tableText(
                'Ir na 12prm falar com o José aldjihalk jdhal kdal dkhja',
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    locationsName = MyFunctons.getHive('locations', names: true);
    MyHomeFormfield dateField = MyHomeFormfield(
        handleTap: () => selectDate(context),
        prefixIcon: Icon(
          Icons.calendar_month,
          color: StdValues.labelGrey,
        ),
        labelTitle: '  Data',
        labelText: '  Selecione uma Data',
        listValidator: const []);
    var visits = [];
    if (locationId == 0) {
      locationId = profile['locations']['id'];
    }

    return MyHomeContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('HISTÓRICO DE VISITAS',
              style: TextStyle(
                  color: StdValues.bkgBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const MyDivider(),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '  Visitas de Hoje',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: StdValues.labelGrey),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TypeAheadField(
                        constraints: const BoxConstraints(maxHeight: 150),
                        controller: dropController,
                        emptyBuilder: (context) => const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text('Nenhum resultado encontrado'),
                            ),
                        builder: (context, controller, focusNode) {
                          return SizedBox(
                            height: 42,
                            child: TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: StdValues.textGrey,
                                  size: 35,
                                ),
                                hintText: 'Selecione uma Cidade',
                                fillColor: Colors.white,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: StdValues.borderFieldGrey)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: StdValues.borderFieldGrey,
                                  ),
                                ),
                                border: const OutlineInputBorder(),
                              ),
                            ),
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
                          if (search.isEmpty) locationsName;
                          List<String> filter = [];

                          for (var i in locationsName) {
                            if (i
                                .toLowerCase()
                                .contains(search.toLowerCase())) {
                              filter.add(i);
                            }
                          }
                          return filter;
                        },
                        onSelected: (suggestion) {
                          dropController.text = suggestion;
                        }),
                    const SizedBox(
                      height: 23,
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              Flexible(flex: 1, child: dateField),
              const SizedBox(
                width: 50,
              ),
              Flexible(
                  flex: 2,
                  child: MyButton(
                    callback: () {},
                    text: 'Buscar',
                    btnWidth: double.infinity,
                  ))
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 30),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                  color: StdValues.shadowGrey)
            ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              height: 500,
              child: SingleChildScrollView(
                child: Table(
                  columnWidths: const {
                    2: FixedColumnWidth(120),
                    3: FixedColumnWidth(80),
                  },
                  children: [
                    TableRow(
                        decoration: BoxDecoration(
                            color: StdValues.bkgBlue,
                            borderRadius: BorderRadius.circular(6)),
                        children: [
                          tableText('Operador',
                              color: false, bold: true, size: 18),
                          tableText('Visitante',
                              color: false, bold: true, size: 18),
                          tableText('Data', color: false, bold: true, size: 18),
                          tableText('Hora', color: false, bold: true, size: 18),
                          tableText('Autorizado por',
                              color: false, bold: true, size: 18),
                          tableText('Finalidade',
                              color: false, bold: true, size: 18),
                        ]),
                    ...buildTableRows()
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
