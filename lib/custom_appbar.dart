import 'package:flutter/material.dart';
import 'package:market_place_test/constants.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppbar({Key key, this.title, this.actions})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

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
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
      title: Text(
        widget.title.toUpperCase(),
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: primary,
      elevation: 0.0,
      actionsIconTheme: IconThemeData(color: Colors.white),
      actions: widget.actions == null ? [] : widget.actions,
    );
  }
}
