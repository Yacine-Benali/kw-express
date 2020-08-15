import 'dart:async';

import 'package:flutter/material.dart';

class SubtitleWidget extends StatefulWidget {
  @override
  _SubtitleWidgetState createState() => _SubtitleWidgetState();
}

class _SubtitleWidgetState extends State<SubtitleWidget> {
  String subtitle;
  Timer timer;
  int index;
  List<String> subtitles = [
    'Meilleure Livraison en Algerie',
    'Commander vos repas maintenants',
    'Satisfaction garantie',
  ];

  TextStyle style;

  @override
  void initState() {
    style = TextStyle(color: Colors.white, fontSize: 16);
    index = 0;
    subtitle = subtitles[0];
    changeOpacity();

    timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        index++;
        setState(() {});
        if (index > 5) index = 0;
      },
    );
    super.initState();
  }

  changeOpacity() {}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: AnimatedOpacity(
            opacity: index == 0 ? 1 : 0,
            duration: Duration(seconds: 1),
            child: Text(
              subtitles[0],
              style: style,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: AnimatedOpacity(
            opacity: index == 2 ? 1 : 0,
            duration: Duration(seconds: 1),
            child: Text(subtitles[1], style: style),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: AnimatedOpacity(
            opacity: index == 4 ? 1 : 0,
            duration: Duration(seconds: 1),
            child: Text(subtitles[2], style: style),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
