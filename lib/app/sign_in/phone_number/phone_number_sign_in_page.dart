import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kwexpress/app/sign_in/phone_number/error_icon_widget.dart';
import 'package:kwexpress/app/sign_in/phone_number/phone_number_sign_in_bloc.dart';
import 'package:kwexpress/app/sign_in/phone_number/subtitle_widget.dart';
import 'package:kwexpress/common_widgets/platform_alert_dialog.dart';
import 'package:kwexpress/common_widgets/platform_exception_alert_dialog.dart';
import 'package:kwexpress/constants/assets_path.dart';
import 'package:kwexpress/constants/size_config.dart';
import 'package:kwexpress/services/auth.dart';
import 'package:provider/provider.dart';

class PhoneNumberSignInPage extends StatefulWidget {
  const PhoneNumberSignInPage._({Key key, @required this.bloc})
      : super(key: key);

  final PhoneNumberSignInBloc bloc;

  static Future<void> show(
    BuildContext context,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => PhoneNumberSignInPage.create(context),
      ),
    );
  }

  static Widget create(BuildContext context, {VoidCallback onSignedIn}) {
    final Auth auth = Provider.of<Auth>(context, listen: false);
    final PhoneNumberSignInBloc bloc = PhoneNumberSignInBloc(auth: auth);
    return PhoneNumberSignInPage._(bloc: bloc);
  }

  @override
  _PhoneNumberSignInPageState createState() => _PhoneNumberSignInPageState();
}

class _PhoneNumberSignInPageState extends State<PhoneNumberSignInPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  PhoneNumberSignInBloc get bloc => widget.bloc;
  bool isSmsSent = false;
  StreamController<bool> controller;

  Stream<bool> smsSentStream;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ErrorIconWidget _errorWidget = ErrorIconWidget(false);
  SvgPicture svg2;
  @override
  void dispose() {
    _phoneNumberController.dispose();
    controller.close();
    super.dispose();
  }

  @override
  void initState() {
    controller = StreamController<bool>();
    svg2 = SvgPicture.asset(
      AssetsPath.logo,
      semanticsLabel: 'logo',
    );

    super.initState();
  }

  _showSignInError(PlatformException e) {
    PlatformExceptionAlertDialog(
      title: 'faild',
      exception: e,
    ).show(context);
  }

  Future<void> _submitPhoneNumber() async {
    try {
      if (_formKey.currentState.validate()) {
        errorWidget = ErrorIconWidget(false);

        //print('value outside ${bloc.getsmsSentStream.value}');

        await bloc.submitPhoneNumber(
          _phoneNumberController.text,
          controller,
        );

        // Future.delayed(Duration(seconds: 3))
        //     .then((value) => setState(() => isSmsSent = true));
      } else {
        errorWidget = ErrorIconWidget(true);
      }
    } on PlatformException catch (e) {
      _showSignInError(e);
    } catch (e) {
      _showSignInError(e);
    }
  }

  Future<void> _submitSmsCode() async {
    try {
      String smsCode = _smsController.text;
      await bloc.submitSmsCode(smsCode);
    } on PlatformException catch (e) {
      _showSignInError(e);
    } catch (e) {
      PlatformAlertDialog(
        title: 'failed',
        content: 'wrong code',
        defaultActionText: 'OK',
      ).show(context);
    }
  }

  set errorWidget(ErrorIconWidget value) {
    setState(() {
      _errorWidget = value;
    });
  }

  Widget _buildSubmitPhoneNumberButton() {
    return ButtonTheme(
      minWidth: SizeConfig.safeBlockHorizontal * 48 - 50,
      height: 50,
      child: OutlineButton(
        child: Text(
          "SUIVANT",
          style: TextStyle(color: Colors.grey[200]),
        ),
        onPressed: () => _submitPhoneNumber(),
        color: Colors.yellow,
        borderSide: BorderSide(
          color: Colors.grey[200],
          width: 3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  Widget _buildSubmitSmsButton() {
    return ButtonTheme(
      minWidth: SizeConfig.safeBlockHorizontal * 48 - 50,
      height: 50,
      child: OutlineButton(
        child: Text(
          "VERIFIER",
          style: TextStyle(color: Colors.grey[200]),
        ),
        onPressed: () => _submitSmsCode(),
        color: Colors.yellow,
        borderSide: BorderSide(
          color: Colors.grey[200],
          width: 3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  Widget _buildSmsField() {
    return SizedBox(
      width: SizeConfig.safeBlockHorizontal * 48 + 50,
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _smsController,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            suffixIcon: _errorWidget,
            counterText: '',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            hintStyle: TextStyle(color: Colors.grey),
            hintText: 'entrer le code reçu',
          ),
          maxLength: 6,
          autocorrect: false,
          keyboardType: TextInputType.phone,
          keyboardAppearance: Brightness.light,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return SizedBox(
      width: SizeConfig.safeBlockHorizontal * 48 + 50,
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _phoneNumberController,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
          //controller: _phoneNumberController,
          decoration: InputDecoration(
            suffixIcon: _errorWidget,
            counterText: '',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            hintStyle: TextStyle(color: Colors.grey),
            hintText: 'entrer vos numero',
          ),
          maxLength: 10,
          autocorrect: false,
          validator: (String phoneNumber) =>
              bloc.validatePhoneNumber(phoneNumber),
          keyboardType: TextInputType.phone,
          keyboardAppearance: Brightness.light,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: SizeConfig.safeBlockVertical * 19,
          width: SizeConfig.safeBlockHorizontal * 48,
          child: Image.asset(AssetsPath.logo2),
        ),
        SizedBox(height: 30),
        SubtitleWidget(),
        SizedBox(height: 30),
        if (!isSmsSent) ...[_buildPhoneNumberField()],
        if (isSmsSent) ...[_buildSmsField()],
        SizedBox(height: 30),
        if (!isSmsSent) ...[_buildSubmitPhoneNumberButton()],
        if (isSmsSent) ...[_buildSubmitSmsButton()],
        SizedBox(height: 50),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return StreamBuilder<bool>(
        stream: controller.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) isSmsSent = snapshot.data;

          return Scaffold(
            extendBodyBehindAppBar: true,
            body: Stack(
              fit: StackFit.expand,
              children: [
                FittedBox(
                  fit: BoxFit.fill,
                  child: Image.asset(AssetsPath.signInBackground2),
                ),
                Center(
                  child: SingleChildScrollView(
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
