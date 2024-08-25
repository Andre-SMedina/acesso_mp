import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

PreferredSizeWidget? myAppbar(BuildContext context, String title) {
  var box = Hive.box('db');
  Map profile = box.get('profile');
  return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(title),
      centerTitle: true,
      actions: [
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  profile['name'],
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 237, 79), fontSize: 17),
                ),
                Text(
                  profile['locations']['name'],
                  style: const TextStyle(
                      color: Color.fromARGB(255, 15, 244, 160),
                      fontSize: 13,
                      height: 0),
                )
              ],
            ),
            const SizedBox(
              width: 25,
            ),
            const Text(
              'Sair',
              style: TextStyle(color: Colors.white),
            ),
            IconButton(
                padding: const EdgeInsets.only(right: 30, left: 10),
                onPressed: () async {
                  var supabase = Supabase.instance.client;
                  await supabase.auth.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, '/');
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        )
      ]);
}
