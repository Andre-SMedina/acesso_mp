import 'package:acesso_mp/helpers/my_functions.dart';
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
  List locations = [];
  int locationId = 0;
  TextEditingController dropController = TextEditingController();
  var box = Hive.box('db');

  // @override
  // void initState() {
  //   MyFunctons.getVisits(profile['locations']['id']);
  //   super.initState();
  // }

  void loadLocationId(int id) {
    locationId = id;
  }

  @override
  Widget build(BuildContext context) {
    locations = MyFunctons.getHive('locations', names: true);
    var visits = [];
    if (locationId == 0) locationId = profile['locations']['id'];
    // visits = MyFunctons.getHive('visits');
    // box.delete('visits');
    // print(visits);

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
              constraints: const BoxConstraints(maxHeight: 700, maxWidth: 1500),
              margin: const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(255, 255, 255, 0.7)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(
                    flex: 1,
                  ),
                  Column(
                    children: [
                      const Text(
                        'Histórico de hoje',
                        style: TextStyle(fontSize: 24),
                      ),
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
                                    labelText: 'Pesquisar local'),
                              );
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            suggestionsCallback: (search) {
                              if (search.isEmpty) locations;
                              List<String> filter = [];

                              for (var i in locations) {
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
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        height: 400,
                        width: 400,
                        child: FutureBuilder(
                          future: MyFunctons.getVisits(locationId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              visits = snapshot.data!;
                            }

                            return ListView.builder(
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
                                    ListTile(
                                      title: RichText(
                                          text: TextSpan(children: [
                                        myText('Operador'),
                                        TextSpan(
                                            text: visits[index]['operators']
                                                ['name']),
                                        myText('\nData'),
                                        TextSpan(text: visits[index]['date']),
                                        myText('\nFinalidade'),
                                        TextSpan(text: visits[index]['goal']),
                                        myText('\nAutorizado por'),
                                        TextSpan(
                                            text: visits[index]
                                                ['authorizedBy']),
                                      ])),
                                    ),
                                    if (index < visits.length) const Divider()
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                  const Column(
                    children: [
                      Text(
                        'Consulta personalizada',
                        style: TextStyle(fontSize: 24),
                      )
                    ],
                  ),
                  const Spacer(
                    flex: 1,
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
