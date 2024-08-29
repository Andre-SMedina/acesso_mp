import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:acesso_mp/helpers/zshow_dialogs.dart';
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
    var box = Hive.box('db');

    void operatorControl() {
      context.read<XProvider>().clearFields();
      Navigator.pushReplacementNamed(context, '/controlOperators');
    }

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            MyListTile(
              iconTip1: '',
              iconTip2: '',
              iconBtn1: Icons.home,
              title: 'Home',
              hoverColor: const Color.fromARGB(255, 97, 6, 182),
              callMain: () {
                MyFunctons.getOperators().then((e) {
                  MyFunctons.putHive('operators', e);
                });
                context.read<XProvider>().clearFields();
                Navigator.pushReplacementNamed(context, '/home');
              },
              actionBtn1: false,
              callIconBtn1: () {},
              callIconBtn2: () {},
            ),
            MyListTile(
              iconTip1: '',
              iconTip2: '',
              iconBtn1: Icons.access_time,
              title: 'Histórico de visitas',
              hoverColor: const Color.fromARGB(255, 97, 6, 182),
              callMain: () {
                context.read<XProvider>().clearFields();
                Navigator.pushReplacementNamed(context, '/history');
              },
              actionBtn1: false,
              callIconBtn1: () {},
              callIconBtn2: () {},
            ),
            MyListTile(
              iconTip1: '',
              iconTip2: '',
              iconBtn1: Icons.person,
              title: 'Controle de operadores',
              hoverColor: const Color.fromARGB(255, 97, 6, 182),
              callMain: () async {
                if (box.get('profile')['adm']) {
                  await MyFunctons.getLocations().then((value) {
                    List listFull = value.map((e) {
                      return e['name'];
                    }).toList();
                    box.put('locationsName', listFull);
                    box.put('locationsFull', value);
                    operatorControl();
                  });
                } else {
                  ZshowDialogs.alert(
                      context, 'Você não tem perfil administrador.');
                }
              },
              actionBtn1: false,
              callIconBtn1: () {},
              callIconBtn2: () {},
            ),
            MyListTile(
              iconTip1: '',
              iconTip2: '',
              iconBtn1: Icons.location_city,
              title: 'Controle de lotação',
              hoverColor: const Color.fromARGB(255, 97, 6, 182),
              callMain: () {
                if (box.get('profile')['adm']) {
                  context.read<XProvider>().clearFields();
                  Navigator.pushReplacementNamed(context, '/controlLocates');
                } else {
                  ZshowDialogs.alert(
                      context, 'Você não tem perfil administrador.');
                }
              },
              actionBtn1: false,
              callIconBtn1: () {},
              callIconBtn2: () {},
            )
          ],
        ),
      ),
    );
  }
}
