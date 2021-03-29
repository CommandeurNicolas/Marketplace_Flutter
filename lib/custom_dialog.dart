import 'package:flutter/material.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

class CustomDialog extends StatefulWidget {
  CustomDialog({
    Key key,
    @required this.title,
    @required this.component,
    @required this.functionOk,
    @required this.buttonOkTitle,
    this.buttonOkIcon = Icons.check_rounded,
    this.buttonOkColor = Colors.green,
  }) : super(key: key);

  final Function functionOk;
  final String title;
  final Widget component;
  final String buttonOkTitle;
  final IconData buttonOkIcon;
  final Color buttonOkColor;

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            widget.component,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconsOutlineButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: 'Cancel',
                  iconData: Icons.cancel_outlined,
                  textStyle: TextStyle(color: Colors.grey),
                  iconColor: Colors.grey,
                ),
                IconsButton(
                  onPressed: widget.functionOk,
                  text: widget.buttonOkTitle,
                  iconData: widget.buttonOkIcon,
                  color: widget.buttonOkColor,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
