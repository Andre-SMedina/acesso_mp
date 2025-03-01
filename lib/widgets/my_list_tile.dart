import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/helpers/zshow_dialogs.dart';
import 'package:flutter/material.dart';

class MyListTile extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String iconTip1;
  final String iconTip2;
  final bool actionBtn1;
  final Color hoverColor;
  final IconData? iconBtn1;
  final IconData? iconBtn2;
  final Icon? icon;
  final VoidCallback callMain;
  final VoidCallback callIconBtn1;
  final VoidCallback callIconBtn2;
  final VoidCallback? callIconPass;
  const MyListTile(
      {super.key,
      required this.title,
      this.subtitle,
      required this.hoverColor,
      this.iconBtn1,
      required this.callIconBtn2,
      this.iconBtn2,
      required this.callMain,
      required this.callIconBtn1,
      required this.iconTip1,
      required this.iconTip2,
      required this.actionBtn1,
      this.callIconPass,
      this.icon});

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        widget.callMain();
      },
      leading: Tooltip(
        message: (widget.iconBtn1 == Icons.admin_panel_settings
            ? widget.iconTip1
            : widget.iconTip2),
        child: (widget.iconBtn1 != null)
            ? IconButton(
                onPressed: () {
                  if (widget.actionBtn1) {
                    ZshowDialogs.confirm(
                            context,
                            (widget.iconBtn1 == Icons.admin_panel_settings)
                                ? 'Tornar usuário comum?'
                                : 'Tornar Administrador?')
                        .then((e) {
                      if (e) {
                        widget.callIconBtn1();
                      }
                    });
                  }
                },
                icon: Icon(
                  widget.iconBtn1,
                  size: 35,
                  color: (widget.iconBtn1 == Icons.admin_panel_settings)
                      ? const Color(0xFFDAA520)
                      : StdValues.btnBlue,
                ),
              )
            : widget.icon,
      ),
      trailing: widget.iconBtn2 != null
          ? Tooltip(
              message: (widget.iconBtn2 == Icons.do_not_disturb_alt_outlined
                  ? 'Usuário bloqueado'
                  : 'Usuário ativo'),
              child: IconButton(
                onPressed: () {
                  ZshowDialogs.confirm(
                          context,
                          (widget.iconBtn2 == Icons.do_not_disturb_alt_outlined)
                              ? 'Desbloquear usuário?'
                              : 'Bloquear usuário?')
                      .then((e) {
                    if (e) {
                      widget.callIconBtn2();
                    }
                  });
                },
                icon: Icon(
                  widget.iconBtn2,
                  size: 35,
                  color: (widget.iconBtn2 == Icons.do_not_disturb_alt_outlined)
                      ? Colors.red
                      : StdValues.btnBlue,
                ),
              ),
            )
          : null,
      title: MouseRegion(
        onEnter: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        cursor: SystemMouseCursors.click,
        child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: isHover ? StdValues.bkgFieldGrey : null),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                (widget.callIconPass != null)
                    ? Tooltip(
                        message: 'Redefinir senha',
                        child: IconButton(
                            onPressed: (widget.callIconPass != null)
                                ? () {
                                    ZshowDialogs.confirm(context,
                                            'Confirmar redefinição de senha?')
                                        .then((e) {
                                      if (e) widget.callIconPass!();
                                    });
                                  }
                                : () {},
                            icon: const Icon(
                              Icons.vpn_key_outlined,
                              color: Color(0xFFDAA520),
                            )),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
      subtitle: (widget.subtitle != null)
          ? Text(
              widget.subtitle!,
              textAlign: TextAlign.center,
            )
          : null,
    );
  }
}
