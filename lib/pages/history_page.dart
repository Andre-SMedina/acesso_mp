import 'package:acesso_mp/widgets/my_appbar.dart';
import 'package:acesso_mp/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  TextStyle title = const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
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
      return Scaffold(
        drawer: const MyDrawer(),
        appBar: myAppbar(context, 'Histórico de Visitas'),
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/mp.jpg'),
                      fit: BoxFit.cover,
                      opacity: 0.3)),
              child: Container(
                  child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [],
                  )
                ],
              ))),
        ),
      );
    }
  }
}
