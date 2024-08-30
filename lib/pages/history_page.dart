import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:acesso_mp/widgets/my_appbar.dart';
import 'package:acesso_mp/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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

  @override
  Widget build(BuildContext context) {
    locationsName = MyFunctons.getHive('locations', names: true);
    var visits = [];
    if (locationId == 0) {
      locationId = profile['locations']['id'];
    } else {}

    if (Supabase.instance.client.auth.currentUser == null) {
      return Scaffold(
        body: Center(
          child: SizedBox(
            height: 100,
            child: Column(
              children: [
                const Text(
                  'Nenhum usuário logado no sistema',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: const Text('Voltar para login'))
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        drawer: const MyDrawer(),
        appBar: myAppbar(context, 'Histórico de Visitas'),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/mp.jpg'),
                fit: BoxFit.cover,
                opacity: 0.3),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 700, maxWidth: 600),
              margin: const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(255, 255, 255, 0.8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 300,
                        child: TypeAheadField(
                            constraints: const BoxConstraints(maxHeight: 150),
                            controller: dropController,
                            emptyBuilder: (context) => const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('Nenhum resultado encontrado'),
                                ),
                            builder: (context, controller, focusNode) {
                              return TextFormField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                    border: OutlineInputBorder(),
                                    labelText: 'Visitas de hoje em...'),
                              );
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
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
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        // height: 85,
                        width: 300,
                        child: Form(
                          child: TextFormField(
                            controller: dateController,
                            decoration: const InputDecoration(
                                label: Text('Data específica')),
                            onTap: () {
                              // FocusScope.of(context).requestFocus(FocusNode());
                              selectDate(context);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: ElevatedButton(
                            onPressed: () {
                              loadLocation(dropController.text);
                            },
                            child: const Text('Buscar')),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2)),
                        height: 400,
                        width: 400,
                        child: FutureBuilder(
                          future: MyFunctons.getVisits(locationId,
                              date: (dateController.text.isNotEmpty)
                                  ? Convert.formatDate(dateController.text,
                                      br: true)
                                  : ''),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              visits = snapshot.data!;
                            }

                            return (visits.isEmpty)
                                ? const Text('Nenhum resultado encontrado!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18))
                                : ListView.builder(
                                    itemCount: visits.length,
                                    itemBuilder: (context, index) {
                                      TextSpan myText(String text) {
                                        return TextSpan(
                                            text: '$text: ',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold));
                                      }

                                      return Column(
                                        children: [
                                          if (index == 0)
                                            Text(
                                              "${visits[0]['locations']['name']} (Visitantes: ${visits.length})",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ListTile(
                                            title: RichText(
                                                text: TextSpan(children: [
                                              myText('Operador'),
                                              TextSpan(
                                                  text: visits[index]
                                                      ['operators']['name']),
                                              myText('\nVisitante'),
                                              TextSpan(
                                                  text: visits[index]
                                                      ['visitors']['name']),
                                              myText('\nData'),
                                              TextSpan(
                                                  text: Convert.formatDate(
                                                      visits[index]['date'])),
                                              myText('\nHora'),
                                              TextSpan(
                                                  text: visits[index]['time']),
                                              myText('\nFinalidade'),
                                              TextSpan(
                                                  text: visits[index]['goal']),
                                              myText('\nAutorizado por'),
                                              TextSpan(
                                                  text: visits[index]
                                                      ['authorizedBy']),
                                            ])),
                                          ),
                                          if (index < visits.length)
                                            const Divider()
                                        ],
                                      );
                                    },
                                  );
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
