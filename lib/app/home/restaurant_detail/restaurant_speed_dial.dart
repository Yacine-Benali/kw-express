import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/common_widgets/custom_icons_icons.dart';
import 'package:kwexpress/constants/app_colors.dart';
import 'package:kwexpress/constants/assets_path.dart';
import 'package:kwexpress/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class RestaurantSpeedDial extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantSpeedDial({
    Key key,
    @required this.restaurant,
  }) : super(key: key);
  @override
  _RestaurantSpeedDialState createState() => _RestaurantSpeedDialState();
}

enum DialogType { commander, reserver }

class _RestaurantSpeedDialState extends State<RestaurantSpeedDial>
    with TickerProviderStateMixin {
  AnimationController _controller;
  SvgPicture phone;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    phone = SvgPicture.asset(AssetsPath.phone);

    super.initState();
  }

  void launchMaps() async {
    String googleUrl = widget.restaurant.location;
    String appleUrl = widget.restaurant.location;

    try {
      if (await UrlLauncher.canLaunch("comgooglemaps://")) {
        print('launching com googleUrl');
        await UrlLauncher.launch(googleUrl);
      } else if (await UrlLauncher.canLaunch(appleUrl)) {
        print('launching apple url');
        await UrlLauncher.launch(appleUrl);
      } else {
        throw 'Could not launch url';
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Widget buildTitle(DialogType dialogType) {
    switch (dialogType) {
      case DialogType.commander:
        return Text(
          'Passer votre commande :',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
        );
        break;
      case DialogType.reserver:
        return Text(
          'Reserver une table :',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
        );
        break;
    }
  }

  // ignore: missing_return
  Widget buildContent(DialogType dialogType) {
    switch (dialogType) {
      case DialogType.commander:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () async =>
                  await UrlLauncher.launch('tel:${Constants.phoneNumer1}'),
              leading: SizedBox(width: 20, height: 20, child: phone),
              title: Text(Constants.phoneNumer1),
            ),
            ListTile(
              onTap: () async =>
                  await UrlLauncher.launch('tel:${Constants.phoneNumber2}'),
              leading: SizedBox(width: 20, height: 20, child: phone),
              title: Text(Constants.phoneNumber2),
            )
          ],
        );
        break;
      case DialogType.reserver:
        return ListTile(
          onTap: () async =>
              await UrlLauncher.launch('tel:${Constants.phoneNumer1}'),
          leading: SizedBox(width: 20, height: 20, child: phone),
          title: Text(Constants.phoneNumer1),
        );
        break;
    }
  }

  Future<void> show(DialogType dialogType) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: buildTitle(dialogType),
        content: buildContent(dialogType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (Platform.isAndroid) ...[
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
        ],
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
                    onPressed: () => show(
                          DialogType.reserver,
                        )),
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
                  onPressed: () => show(
                    DialogType.commander,
                  ),
                ),
              ],
            ),
          ),
        ),
      ]..add(
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              backgroundColor: AppColors.colorPrimary,
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
