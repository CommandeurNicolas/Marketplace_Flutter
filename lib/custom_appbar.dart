import 'package:flutter/material.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppbar({Key key, this.title, this.actions, this.popReturn})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  final dynamic popReturn;
  final String title;
  final List<Widget> actions;

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppbarState createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: ModalRoute.of(context).isFirst
          ? Container()
          : IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context, widget.popReturn);
              },
            ),
      title: Text(
        widget.title[0].toUpperCase() + widget.title.substring(1),
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0.0,
      actionsIconTheme: IconThemeData(color: Colors.black),
      actions: widget.actions == null ? [] : widget.actions,
    );
  }
}
