import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kwexpress/app/home/client_space/client_space_bloc.dart';
import 'package:kwexpress/common_widgets/custom_icons_icons.dart';
import 'package:kwexpress/constants/app_colors.dart';
import 'package:kwexpress/constants/assets_path.dart';
import 'package:kwexpress/constants/constants.dart';
import 'package:kwexpress/constants/size_config.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:kwexpress/services/auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientServiceScreen extends StatefulWidget {
  @override
  _ClientServiceScreenState createState() => _ClientServiceScreenState();
}

class _ClientServiceScreenState extends State<ClientServiceScreen> {
  ClientSpaceBloc bloc;
  SvgPicture poweredBy;
  String appLink;
  SvgPicture phoneSvg;
  SvgPicture facebookSvg;
  SvgPicture messengerSvg;
  SvgPicture viberSvg;
  SvgPicture gmailSvg;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> claimTypeList = ["Restaurant", "Livraison", "Autre"];
  String claimType;
  @override
  void initState() {
    claimType = claimTypeList[0];
    APIService api = Provider.of<APIService>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    bloc = ClientSpaceBloc(
      apiService: api,
      auth: auth,
    );
    if (Platform.isIOS)
      appLink = 'https://apps.apple.com/us/app/id1533417111';
    else
      appLink = 'android app link';

    poweredBy = SvgPicture.asset(AssetsPath.poweredBy);
    phoneSvg = SvgPicture.asset(AssetsPath.phone);
    facebookSvg = SvgPicture.asset(AssetsPath.facebook);
    messengerSvg = SvgPicture.asset(AssetsPath.messenger);
    viberSvg = SvgPicture.asset(AssetsPath.viber);
    gmailSvg = SvgPicture.asset(AssetsPath.gmail);

    super.initState();
  }

  Future<void> buildContactDirect() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(
          'Contacter nous par',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: SizedBox(width: 20, height: 20, child: phoneSvg),
              title: Text('Télephone'),
              onTap: () async => await launch('tel:${Constants.phoneNumber2}'),
            ),
            ListTile(
              leading: SizedBox(width: 20, height: 20, child: facebookSvg),
              title: Text('Facebook'),
              onTap: () async {
                String fbProtocolUrl;
                if (Platform.isIOS) {
                  fbProtocolUrl = 'fb://profile/1245238658965258';
                } else {
                  fbProtocolUrl = 'fb://page/1245238658965258';
                }

                String fallbackUrl =
                    'https://www.facebook.com/1245238658965258/';
                try {
                  bool launched =
                      await launch(fbProtocolUrl, forceSafariVC: false);

                  if (!launched) {
                    await launch(fallbackUrl, forceSafariVC: false);
                  }
                } catch (e) {
                  await launch(fallbackUrl, forceSafariVC: false);
                }
              },
            ),
            ListTile(
              leading: SizedBox(width: 20, height: 20, child: messengerSvg),
              title: Text('Messenger'),
              onTap: () async {
                try {
                  await launch("http://m.me/475527699675914");
                } catch (e) {}
              },
            ),
            ListTile(
              leading: SizedBox(width: 20, height: 20, child: viberSvg),
              title: Text('Viber'),
              onTap: () async => await launch('tel:${Constants.phoneNumber2}'),
            ),
            ListTile(
              leading: SizedBox(width: 20, height: 20, child: gmailSvg),
              title: Text('Gmail'),
              onTap: () async {
                final Uri _emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'kw.entreprise.dz@gmail.com',
                    queryParameters: {'subject': 'Service Client KW Express'});

                launch(_emailLaunchUri.toString());
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> buildNewRestaurant() async {
    String restaurantName;
    String restaurantPhoneNumber;
    String restaurantAddress;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            'Remplissez les champs ci-dessous',
          ),
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      counterText: '',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.indigo,
                        ),
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: 'Nom du restaurant',
                    ),
                    onChanged: (value) => restaurantName = value,
                    validator: (value) =>
                        value.isEmpty ? 'ce champ est obligatoir' : null,
                    maxLength: 30,
                    keyboardAppearance: Brightness.light,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      counterText: '',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.indigo,
                        ),
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: 'Numero du telephone',
                    ),
                    onChanged: (value) => restaurantPhoneNumber = value,
                    validator: (value) =>
                        value.isEmpty ? 'ce champ est obligatoir' : null,
                    maxLength: 30,
                    keyboardAppearance: Brightness.light,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      counterText: '',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.indigo,
                        ),
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: 'address du restaurant',
                    ),
                    onChanged: (value) => restaurantAddress = value,
                    validator: (value) =>
                        value.isEmpty ? 'ce champ est obligatoir' : null,
                    maxLength: 30,
                    keyboardAppearance: Brightness.light,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: AppColors.colorPrimary),
                    ),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        bloc.sendNewRestaurant(
                          restaurantName,
                          restaurantPhoneNumber,
                          restaurantAddress,
                        );
                        Navigator.of(context).pop();
                        final snackBar = SnackBar(
                          content: Text('Message bien envoyé'),
                          duration: Duration(milliseconds: 500),
                        );
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                      }
                    },
                    color: Colors.white,
                    textColor: Colors.red,
                    child: Text(
                      "envoyer".toUpperCase(),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> buildNewBug() async {
    String bugDescription;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            'Description du probleme: ',
          ),
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      counterText: '',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.indigo,
                        ),
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: 'Description ici',
                    ),
                    onChanged: (value) => bugDescription = value,
                    validator: (value) =>
                        value.length < 10 ? 'min 10 caracteres' : null,
                    maxLength: 60,
                    keyboardAppearance: Brightness.light,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: AppColors.colorPrimary),
                    ),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        bloc.sendNewBug(bugDescription);
                        Navigator.of(context).pop();
                        final snackBar = SnackBar(
                          content: Text('Message bien envoyé'),
                          duration: Duration(milliseconds: 500),
                        );
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                      }
                    },
                    color: Colors.white,
                    textColor: Colors.red,
                    child: Text(
                      "envoyer".toUpperCase(),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> buildNewClaim() async {
    String claimDescription;

    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Description du probleme: ',
            ),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  DropdownButton<String>(
                    dropdownColor: Colors.white,
                    value: claimType,
                    iconSize: 24,
                    elevation: 0,
                    onChanged: (String newValue) {
                      claimType = newValue;
                      setState(() {});
                    },
                    items: claimTypeList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: '',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.indigo,
                          ),
                        ),
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: 'Description ici',
                      ),
                      onChanged: (value) => claimDescription = value,
                      validator: (value) =>
                          value.length < 10 ? 'min 10 caracteres' : null,
                      maxLength: 60,
                      keyboardAppearance: Brightness.light,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: AppColors.colorPrimary),
                      ),
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          bloc.sendNewRecelamation(claimType, claimDescription);
                          Navigator.of(context).pop();
                          final snackBar = SnackBar(
                            content: Text('Message bien envoyé'),
                            duration: Duration(milliseconds: 500),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        }
                      },
                      color: Colors.white,
                      textColor: Colors.red,
                      child: Text(
                        "envoyer".toUpperCase(),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> buildNewSuggestion() async {
    String description;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            'Votre suggestiion: ',
          ),
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      counterText: '',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.indigo,
                        ),
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: 'Suggestion ici',
                    ),
                    onChanged: (value) => description = value,
                    validator: (value) =>
                        value.isEmpty ? 'Il faut remplir ce champ' : null,
                    maxLength: 60,
                    keyboardAppearance: Brightness.light,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: AppColors.colorPrimary),
                    ),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        bloc.sendNewSuggestion(description);
                        Navigator.of(context).pop();
                        final snackBar = SnackBar(
                          content: Text('Message bien envoyé'),
                          duration: Duration(milliseconds: 500),
                        );
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                      }
                    },
                    color: Colors.white,
                    textColor: Colors.red,
                    child: Text(
                      "envoyer".toUpperCase(),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Text('Service Client', style: TextStyle(color: Colors.grey)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ListTile(
                    leading: Icon(
                      CustomIcons.telephone,
                      color: AppColors.colorPrimary,
                    ),
                    title: Text(
                      'Contact Direct',
                      style: TextStyle(color: AppColors.textBig, fontSize: 13),
                    ),
                    onTap: () => buildContactDirect(),
                  ),
                  ListTile(
                    leading: Icon(
                      CustomIcons.ic_dinner,
                      color: AppColors.colorPrimary,
                    ),
                    title: Text(
                      'Nouveau Restaurant',
                      style: TextStyle(color: AppColors.textBig, fontSize: 13),
                    ),
                    onTap: () => buildNewRestaurant(),
                  ),
                  ListTile(
                    leading: Icon(
                      CustomIcons.bug,
                      color: AppColors.colorPrimary,
                    ),
                    title: Text(
                      'Bug',
                      style: TextStyle(color: AppColors.textBig, fontSize: 13),
                    ),
                    onTap: () => buildNewBug(),
                  ),
                  ListTile(
                    leading: Icon(
                      CustomIcons.reclamation,
                      color: AppColors.colorPrimary,
                    ),
                    title: Text(
                      'Reclamation',
                      style: TextStyle(color: AppColors.textBig, fontSize: 13),
                    ),
                    onTap: () => buildNewClaim(),
                  ),
                  ListTile(
                    leading: Icon(
                      CustomIcons.suggestion,
                      color: AppColors.colorPrimary,
                    ),
                    title: Text(
                      'Nouveau Restaurant',
                      style: TextStyle(color: AppColors.textBig, fontSize: 13),
                    ),
                    onTap: () => buildNewSuggestion(),
                  ),
                ],
              ),
            ),
            Container(
              height: SizeConfig.screenHeight - (kMinInteractiveDimension * 8),
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
          ],
        ),
      ),
    );
  }
}
