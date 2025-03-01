import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/widgets/history/history_functions.dart';
import 'package:acesso_mp/widgets/home/my_home_container.dart';
import 'package:acesso_mp/widgets/home/my_formfield.dart';
import 'package:acesso_mp/widgets/my_button.dart';
import 'package:acesso_mp/widgets/my_divider.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
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
  bool selectedLocation = false;

  TextEditingController dropController = TextEditingController();
  MaskedTextController dateController =
      MaskedTextController(mask: '00/00/0000');
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    String addZero(int date) {
      if (date.toString().length < 2) return '0$date';
      return date.toString();
    }

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 300,
              width: 300,
              child: DatePicker(
                  centerLeadingDate: true,
                  maxDate: DateTime(2101),
                  minDate: DateTime(2000),
                  initialDate: DateTime.now(),
                  onDateSelected: (value) {
                    dateController.text =
                        "${addZero(value.day)}/${addZero(value.month)}/${value.year}";
                    Navigator.pop(context);
                  }),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    MyFormfield dateField = MyFormfield(
        maskedController: dateController,
        prefixIconBtn: IconButton(
          onPressed: () => selectDate(context),
          icon: const Icon(Icons.calendar_month),
          color: StdValues.labelGrey,
        ),
        labelTitle: '  Data',
        labelText: '  Selecione uma Data',
        listValidator: const []);
    locationsName = MyFunctons.getHive('locations', names: true);

    var visits = [];
    if (locationId == 0) {
      locationId = profile['locations']['id'];
    }

    return MyHomeContainer(
      difHeight: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('HISTÓRICO DE VISITAS', style: StdValues.title),
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
                            child: Form(
                              key: formKey,
                              child: TextFormField(
                                onTap: () {
                                  dropController.selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset: dropController.text.length,
                                  );
                                },
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
                                  hoverColor: Colors.white,
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
                          selectedLocation = true;
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
                    callback: () {
                      if (selectedLocation) {
                        loadLocation(dropController.text);
                      } else {
                        ZshowDialogs.alert(context, 'Escolha uma Cidade!');
                      }
                    },
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
              width: double.infinity,
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: MyFunctons.getVisits(locationId,
                      date: (dateController.text.isNotEmpty)
                          ? Convert.formatDate(dateController.text, br: true)
                          : ''),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      visits = snapshot.data!;
                    }

                    return (visits.isEmpty)
                        ? const Text('Nenhum resultado encontrado!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18))
                        : Table(
                            columnWidths: const {
                              2: FixedColumnWidth(120),
                              3: FixedColumnWidth(120),
                              4: FixedColumnWidth(180),
                            },
                            children: [
                              HistoryFunctions.tableColumns(),
                              ...HistoryFunctions.buildTableRows(
                                  visits.length, visits)
                            ],
                          );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
