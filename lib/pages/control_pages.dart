import 'package:acesso_mp/pages/home_page2.dart';
import 'package:acesso_mp/widgets/my_appbar.dart';
import 'package:acesso_mp/widgets/my_list_tile_menu.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ControlPages extends StatefulWidget {
  final List<CameraDescription> cameras;
  const ControlPages({super.key, required this.cameras});

  @override
  State<ControlPages> createState() => _ControlPagesState();
}

class _ControlPagesState extends State<ControlPages> {
  int selectedIndex = 0;
  Widget? page;

  void onSelect(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void homePage() {
    page = const HomePage2();
  }

  @override
  Widget build(BuildContext context) {
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
      homePage();
      return Scaffold(
        appBar: myAppbar(context, 'Controle de Acesso ao Ministério Público'),
        body: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10),
              height: double.infinity,
              width: 300,
              color: const Color.fromARGB(255, 225, 225, 225),
              child: Column(
                children: [
                  MyListTile2(
                    index: 0,
                    selectedIndex: selectedIndex,
                    onSelect: onSelect,
                    title: 'Painel Principal',
                    icon: Icons.home_outlined,
                    callMain: () {
                      homePage();
                    },
                  ),
                  MyListTile2(
                    index: 1,
                    selectedIndex: selectedIndex,
                    onSelect: onSelect,
                    title: 'Histórico de Visita',
                    icon: Icons.access_time,
                    callMain: () {},
                  ),
                  MyListTile2(
                    index: 2,
                    selectedIndex: selectedIndex,
                    onSelect: onSelect,
                    title: 'Controle de Operadores',
                    icon: Icons.supervisor_account,
                    callMain: () {},
                  ),
                  MyListTile2(
                    index: 3,
                    selectedIndex: selectedIndex,
                    onSelect: onSelect,
                    title: 'Controle de Lotação',
                    icon: Icons.maps_home_work_outlined,
                    callMain: () {},
                  ),
                ],
              ),
            ),
            page!
          ],
        ),
      );
    }
  }
}
