import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/services/x_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

PreferredSizeWidget? myAppbar(BuildContext context, String title) {
  var box = Hive.box('db');
  Map profile = box.get('profile');
  return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      backgroundColor: StdValues.bkgBlue,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Padding(
        padding: const EdgeInsets.only(left: 55),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120,
              height: 100,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/miniLogo.png'))),
            ),
            Text(title),
            Row(
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 50,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      profile['name'],
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined),
                        Text(
                          profile['locations']['name'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13, height: 0),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            VerticalDivider(
              color: StdValues.dividerGrey,
              endIndent: 20,
              indent: 20,
              thickness: 2,
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
                  context.read<XProvider>().clearFields();
                  Navigator.pushReplacementNamed(context, '/');
                  var supabase = Supabase.instance.client;
                  await supabase.auth.signOut();
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        )
      ]);
}
