import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class CupertinoListTile extends StatefulWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget trailing;

  const CupertinoListTile(
      {Key key, this.leading, this.title, this.subtitle, this.trailing})
      : super(key: key);

  @override
  _StatefulStateCupertino createState() => _StatefulStateCupertino();
}

class _StatefulStateCupertino extends State<CupertinoListTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        widget.leading ?? Container(),
        SizedBox(width: 20),
        Center(child: Text(widget.title, style: TextStyle())),
      ],
    );
  }
}
