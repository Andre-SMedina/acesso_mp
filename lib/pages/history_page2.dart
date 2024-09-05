import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/widgets/home/my_home_container.dart';
import 'package:acesso_mp/widgets/home/my_home_formfield.dart';
import 'package:acesso_mp/widgets/my_button.dart';
import 'package:acesso_mp/widgets/my_divider.dart';
import 'package:flutter/material.dart';
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
      {double? size, bool? bold = false, bool? grey = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: bold! ? FontWeight.bold : FontWeight.normal,
              fontSize: (size != null) ? size : 16,
              color: (grey!) ? StdValues.textGrey : Colors.black)),
    );
  }

  List<TableRow> buildTableRows() {
    return List.generate(
      30, // Substitua com o tamanho da sua lista de dados
      (index) => TableRow(
        decoration: BoxDecoration(
          color: index % 2 == 0 ? StdValues.bkgFieldGrey : Colors.white,
        ),
        children: [
          tableText('Maria de Jesus Carvalho'),
          tableText('Pedro Alvarre Cabal'),
          tableText('22/07/2024'),
          tableText('22:50'),
          tableText('Ana Beatri Melo de Sousa '),
          tableText('Ir na 12prm falar com o José'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    locationsName = MyFunctons.getHive('locations', names: true);
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
                child: MyHomeFormfield(
                    sufixIcon: Icon(
                      Icons.search,
                      color: StdValues.labelGrey,
                      size: 30,
                    ),
                    labelText: '  Selecione uma Cidade',
                    labelTitle: '  Visitas de Hoje',
                    listValidator: const []),
              ),
              const SizedBox(
                width: 50,
              ),
              Flexible(
                  flex: 1,
                  child: MyHomeFormfield(
                      prefixIcon: Icon(
                        Icons.calendar_month,
                        color: StdValues.labelGrey,
                      ),
                      labelTitle: '  Data',
                      labelText: '  Selecione uma Data',
                      listValidator: const [])),
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
                    TableRow(children: [
                      tableText('Operador', grey: true, bold: true, size: 18),
                      tableText('Visitante', grey: true, bold: true, size: 18),
                      tableText('Data', grey: true, bold: true, size: 18),
                      tableText('Hora', grey: true, bold: true, size: 18),
                      tableText('Autorizado por',
                          grey: true, bold: true, size: 18),
                      tableText('Finalidade', grey: true, bold: true, size: 18),
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
