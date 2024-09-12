import 'package:acesso_mp/helpers/my_functions.dart';
import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/pages/control_locates2.dart';
import 'package:acesso_mp/pages/control_operators_page2.dart';
import 'package:acesso_mp/pages/history_page2.dart';
import 'package:acesso_mp/pages/home_page2.dart';
import 'package:acesso_mp/services/x_provider.dart';
import 'package:acesso_mp/widgets/my_appbar.dart';
import 'package:acesso_mp/widgets/my_list_tile_menu.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class ControlPages extends StatefulWidget {
  final List<CameraDescription> cameras;
  const ControlPages({super.key, required this.cameras});

  @override
  State<ControlPages> createState() => _ControlPagesState();
}

class _ControlPagesState extends State<ControlPages> {
  int selectedIndex = 0;
  Widget loadPage = const HomePage2();
  bool userProfile = MyFunctons.getHive('profile')['adm'];

  void onSelect(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // changePage(const HomePage2());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppbar(context, 'Controle de Acesso ao Ministério Público'),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            height: double.infinity,
            width: 300,
            color: StdValues.bkgGrey,
            child: Column(
              children: [
                MyListTile2(
                  index: 0,
                  selectedIndex: selectedIndex,
                  onSelect: onSelect,
                  title: 'Painel Principal',
                  icon: Icons.home_outlined,
                  callMain: () {
                    MyFunctons.getOperators().then((e) {
                      MyFunctons.putHive('operators', e);
                    });
                    context.read<XProvider>().clearFields();
                    setState(() {
                      loadPage = const HomePage2();
                    });
                  },
                ),
                MyListTile2(
                  index: 1,
                  selectedIndex: selectedIndex,
                  onSelect: onSelect,
                  title: 'Histórico de Visita',
                  icon: Icons.access_time,
                  callMain: () {
                    context.read<XProvider>().clearFields();
                    setState(() {
                      loadPage = const HistoryPage2();
                    });
                  },
                ),
                MyListTile2(
                  index: 2,
                  selectedIndex: selectedIndex,
                  onSelect: onSelect,
                  title: 'Controle de Atendentes',
                  icon: Icons.supervisor_account_outlined,
                  callMain: () async {
                    if (userProfile) {
                      var box = Hive.box('db');

                      await MyFunctons.getLocations().then((value) {
                        List listFull = value.map((e) {
                          return e['name'];
                        }).toList();
                        box.put('locationsName', listFull);
                        box.put('locationsFull', value);
                      });

                      loadPage = ControlOperatorsPage2();
                    } else {
                      ZshowDialogs.alert(context, 'Acesso negado!');
                    }
                    setState(() {});
                  },
                ),
                MyListTile2(
                  index: 3,
                  selectedIndex: selectedIndex,
                  onSelect: onSelect,
                  title: 'Controle de Lotação',
                  icon: Icons.maps_home_work_outlined,
                  callMain: () {
                    setState(() {
                      if (userProfile) {
                        loadPage = const ControlLocates2();
                      } else {
                        ZshowDialogs.alert(context, 'Acesso negado!');
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.only(top: 25), child: loadPage))
        ],
      ),
    );
  }
}
