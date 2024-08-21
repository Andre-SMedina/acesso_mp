import 'package:acesso_mp/services/db_manage.dart';
import 'package:acesso_mp/services/x_provider.dart';
import 'package:acesso_mp/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            MyListTile(
              icon: Icons.home,
              title: 'Home',
              hoverColor: const Color.fromARGB(255, 97, 6, 182),
              callMain: () {
                context.read<XProvider>().clearFields();
                Navigator.pushReplacementNamed(context, '/home');
              },
              callIcon: () {},
            ),
            MyListTile(
              icon: Icons.person,
              title: 'Controle de operadores',
              hoverColor: const Color.fromARGB(255, 97, 6, 182),
              callMain: () async {
                await DbManage.getLocations().then((value) {
                  var box = Hive.box('db');
                  List listFull = value.map((e) {
                    return e['name'];
                  }).toList();
                  box.put('locations', listFull);
                });

                context.read<XProvider>().clearFields();
                Navigator.pushReplacementNamed(context, '/controlOperators');
              },
              callIcon: () {},
            ),
            MyListTile(
              icon: Icons.location_city,
              title: 'Controle de lotação',
              hoverColor: const Color.fromARGB(255, 97, 6, 182),
              callMain: () {
                context.read<XProvider>().clearFields();
                Navigator.pushReplacementNamed(context, '/controlLocates');
              },
              callIcon: () {},
            )
          ],
        ),
      ),
    );
  }
}
