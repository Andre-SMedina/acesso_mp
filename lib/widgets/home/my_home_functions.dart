import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:acesso_mp/models/model_visitors.dart';
import 'package:acesso_mp/services/database.dart';
import 'package:flutter/material.dart';

class MyHomeFunctions {
  final BuildContext context;
  final GlobalKey<FormState> formKey;
  final Function() getDataVisitor;
  final Function() alertVisited;
  final Function() clearFields;
  MyHomeFunctions({
    required this.formKey,
    required this.getDataVisitor,
    required this.context,
    required this.alertVisited,
    required this.clearFields,
  });

  void update() async {
    if (formKey.currentState!.validate()) {
      bool validate = false;

      await ZshowDialogs.confirm(context, 'Deseja atualizar os dados?')
          .then((e) {
        validate = e;
      });

      if (!validate) return;
      List dataVisitor = getDataVisitor();
      if (dataVisitor[5] != '') {
        final Database db = Database(alertVisited: alertVisited);

        db
            .register(
                ModelVisitors(
                  name: dataVisitor[0],
                  cpf: dataVisitor[1],
                  rg: dataVisitor[2],
                  phone: dataVisitor[3],
                  job: dataVisitor[4],
                  image: dataVisitor[5],
                ),
                // ignore: use_build_context_synchronously
                'update',
                // ignore: use_build_context_synchronously
                context)
            .then((v) {
          if (v == 'updated') {
            ZshowDialogs.alert(context, 'Registro atualizado!');
          } else {
            ZshowDialogs.alert(context, 'Registro não encontrado!');
          }
        });
      } else {
        // ignore: use_build_context_synchronously
        ZshowDialogs.alert(context, 'Imagem não capturada!');
      }
    }
  }

  void register() {
    if (formKey.currentState!.validate()) {
      List dataVisitor = getDataVisitor();

      if (dataVisitor[5] != '') {
        final Database db = Database(alertVisited: alertVisited);

        db
            .register(
                ModelVisitors(
                  name: dataVisitor[0],
                  cpf: dataVisitor[1],
                  rg: dataVisitor[2],
                  phone: dataVisitor[3],
                  job: dataVisitor[4],
                  image: dataVisitor[5],
                ),
                'save',
                context)
            .then((v) {
          if (v == 'saved') {
            ZshowDialogs.alert(context, 'Cadastro realizado com sucesso!');
            clearFields();
          } else if (v == 'exist') {
            ZshowDialogs.alert(context, 'CPF já cadastrado!',
                subTitle: 'Selecione "Limpar" para depois cadastrar.');
          } else if (v == 'cpfExist') {
            ZshowDialogs.alert(context, 'CPF já cadastrado!');
          }
        });
      } else {
        ZshowDialogs.alert(context, 'Imagem não capturada!');
      }
    }
  }
}
