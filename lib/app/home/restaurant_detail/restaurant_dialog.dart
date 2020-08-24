import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kwexpress/common_widgets/platform_widget.dart';
import 'package:kwexpress/constants/assets_path.dart';
import 'package:kwexpress/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';

enum DialogType { commander, reserver }

class RestaurantDialog extends PlatformWidget {
  RestaurantDialog({@required this.dialogType});

  final DialogType dialogType;
  final SvgPicture phone = SvgPicture.asset(AssetsPath.phone);

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (context) => this,
          )
        : await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (context) => this,
          );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return Material(
      child: CupertinoAlertDialog(
        title: buildTitle(),
        content: buildContent(),
      ),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: buildTitle(),
      content: buildContent(),
    );
  }

  // ignore: missing_return
  Widget buildTitle() {
    switch (this.dialogType) {
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
  Widget buildContent() {
    switch (this.dialogType) {
      case DialogType.commander:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () async => await launch('tel://${Constants.phoneNumer1}'),
              leading: SizedBox(width: 20, height: 20, child: phone),
              title: Text(Constants.phoneNumer1),
            ),
            ListTile(
              onTap: () async =>
                  await launch('tel://${Constants.phoneNumber2}'),
              leading: SizedBox(width: 20, height: 20, child: phone),
              title: Text(Constants.phoneNumber2),
            )
          ],
        );
        break;
      case DialogType.reserver:
        return ListTile(
          leading: SizedBox(width: 20, height: 20, child: phone),
          title: Text(Constants.phoneNumer1),
        );
        break;
    }
  }
}
