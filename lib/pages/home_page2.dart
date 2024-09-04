import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/main.dart';
import 'package:acesso_mp/services/x_provider.dart';
import 'package:acesso_mp/widgets/home/my_home_fields.dart';
import 'package:acesso_mp/widgets/my_divider.dart';
import 'package:acesso_mp/widgets/my_dropdown.dart';
import 'package:acesso_mp/widgets/home/my_home_container.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  List<String> visitor = [];
  String image = '';

  bool loadImage = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void loadData() {
    var box = Hive.box('db');
    var visitor = box.get('visitor');

    loadImage = true;
    image = visitor['image'];
    box.put('image', visitor['image']);
    setState(() {});
    formKey.currentState!.reset();
    context.read<XProvider>().loadVisitorsField(visitor);
  }

  alertCamera() {
    ZshowDialogs.alert(context, 'A aplicação apresentou erro');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyHomeContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('VISITANTE',
                  style: TextStyle(
                      color: StdValues.bkgBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const MyDivider(),
              const SizedBox(
                height: 10,
              ),
              const Text(
                '  Pesquisar por visitante',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 105, 105, 105)),
              ),
              SizedBox(
                width: 500,
                child: MyDropdown(loadData: () {
                  loadData();
                }),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        MyHomeFields(
          visitor: visitor,
          formKey: formKey,
          context: context,
          cameras: cameras,
          image: image,
          loadImage: loadImage,
          alertCamera: alertCamera,
        )
      ],
    );
  }
}
