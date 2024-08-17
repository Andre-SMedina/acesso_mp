import 'package:acesso_mp/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';

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
              call: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            MyListTile(
              icon: Icons.person,
              title: 'Controle de operadores',
              hoverColor: const Color.fromARGB(255, 97, 6, 182),
              call: () =>
                  Navigator.pushReplacementNamed(context, '/controlOperators'),
            ),
            MyListTile(
              icon: Icons.location_city,
              title: 'Controle de lotação',
              hoverColor: const Color.fromARGB(255, 97, 6, 182),
              call: () =>
                  Navigator.pushReplacementNamed(context, '/controlLocates'),
            )
          ],
        ),
      ),
    );
  }
}
