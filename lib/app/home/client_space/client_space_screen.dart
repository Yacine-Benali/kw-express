import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kwexpress/app/home/client_space/client_service_screen.dart';
import 'package:kwexpress/app/home/client_space/client_space_bloc.dart';
import 'package:kwexpress/common_widgets/custom_icons_icons.dart';
import 'package:kwexpress/constants/app_colors.dart';
import 'package:kwexpress/constants/assets_path.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ClientSpaceScreen extends StatefulWidget {
  @override
  _ClientSpaceScreenState createState() => _ClientSpaceScreenState();
}

class _ClientSpaceScreenState extends State<ClientSpaceScreen> {
  ClientSpaceBloc bloc;
  SvgPicture poweredBy;
  String appLink;

  @override
  void initState() {
    poweredBy = SvgPicture.asset(AssetsPath.poweredBy);
    if (Platform.isIOS)
      appLink = 'android app link';
    else
      appLink = 'ios app link';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Text('Espace Client', style: TextStyle(color: Colors.grey)),
      ),
      body: Column(
        children: [
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ListTile(
                  leading: Icon(
                    CustomIcons.share,
                    color: AppColors.colorPrimary,
                  ),
                  title: Text(
                    'inviter vos amis',
                    style: TextStyle(color: AppColors.textBig, fontSize: 13),
                  ),
                  onTap: () => Share.share(appLink),
                ),
                ListTile(
                  leading: Icon(
                    CustomIcons.contact,
                    color: AppColors.colorPrimary,
                  ),
                  title: Text(
                    'Service Client',
                    style: TextStyle(color: AppColors.textBig, fontSize: 13),
                  ),
                  onTap: () => Navigator.of(context, rootNavigator: false).push(
                    MaterialPageRoute(
                      builder: (context) => ClientServiceScreen(),
                      fullscreenDialog: true,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    CustomIcons.faq,
                    color: AppColors.colorPrimary,
                  ),
                  title: Text(
                    'Questions Frequentes',
                    style: TextStyle(color: AppColors.textBig, fontSize: 13),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    CustomIcons.note,
                    color: AppColors.colorPrimary,
                  ),
                  title: Text(
                    'Noter l\'application',
                    style: TextStyle(color: AppColors.textBig, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'poweredBy',
                      style: GoogleFonts.cedarvilleCursive(
                        color: AppColors.colorPrimary,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: poweredBy,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
