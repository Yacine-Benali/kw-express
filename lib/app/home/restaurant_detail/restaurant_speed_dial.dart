import 'package:flutter/material.dart';
import 'package:kwexpress/app/home/restaurant_detail/restaurant_dialog.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'dart:math' as math;

import 'package:kwexpress/common_widgets/custom_icons_icons.dart';
import 'package:kwexpress/constants/app_colors.dart';
import 'package:kwexpress/constants/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantSpeedDial extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantSpeedDial({
    Key key,
    @required this.restaurant,
  }) : super(key: key);
  @override
  _RestaurantSpeedDialState createState() => _RestaurantSpeedDialState();
}

class _RestaurantSpeedDialState extends State<RestaurantSpeedDial>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    super.initState();
  }

  void launchMaps() async {
    String googleUrl = widget.restaurant.location;
    String appleUrl = widget.restaurant.location;
    if (await canLaunch("comgooglemaps://")) {
      print('launching com googleUrl');
      await launch(googleUrl);
    } else if (await canLaunch(appleUrl)) {
      print('launching apple url');
      await launch(appleUrl);
    } else {
      throw 'Could not launch url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 70.0,
          alignment: FractionalOffset.centerRight,
          child: FadeTransition(
            // opacity: _fadeInFadeOut,
            opacity: CurvedAnimation(
              parent: _controller,
              curve: Interval(
                0.0,
                1.0 - 0 / 2 / 2.0,
                curve: Curves.easeOut,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: null,
                    disabledColor: Colors.white,
                    disabledElevation: 2,
                    child: Text(
                      "Trouver",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ),
                FloatingActionButton(
                  heroTag: null,
                  backgroundColor: AppColors.colorPrimary,
                  mini: true,
                  child: Icon(CustomIcons.map, color: Colors.white),
                  onPressed: () => launchMaps(),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 70.0,
          alignment: FractionalOffset.centerRight,
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: _controller,
              curve: Interval(
                0.0,
                1.0 - 1 / 2 / 2.0,
                curve: Curves.easeOut,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: null,
                    disabledColor: Colors.white,
                    disabledElevation: 2,
                    child: Text(
                      "Reserver",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ),
                FloatingActionButton(
                  heroTag: null,
                  backgroundColor: AppColors.colorPrimary,
                  mini: true,
                  child: Icon(CustomIcons.reservation, color: Colors.white),
                  onPressed: () => RestaurantDialog(
                    dialogType: DialogType.reserver,
                  ).show(context),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 70.0,
          alignment: FractionalOffset.centerRight,
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: _controller,
              curve: Interval(
                0.0,
                1.0 - 2 / 2 / 2.0,
                curve: Curves.easeIn,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: null,
                    disabledColor: Colors.white,
                    disabledElevation: 2,
                    child: Text(
                      "Commander",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ),
                FloatingActionButton(
                  heroTag: null,
                  backgroundColor: AppColors.colorPrimary,
                  mini: true,
                  child: Icon(CustomIcons.commande, color: Colors.white),
                  onPressed: () => RestaurantDialog(
                    dialogType: DialogType.commander,
                  ).show(context),
                ),
              ],
            ),
          ),
        ),
      ]..add(
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: null,
              child: Icon(CustomIcons.order),
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
            ),
          ),
        ),
    );
  }
}
