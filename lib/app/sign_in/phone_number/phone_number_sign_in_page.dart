import 'dart:async';

import 'package:flutter_svg/svg.dart';
import 'package:kwexpress/app/sign_in/phone_number/phone_number_sign_in_model.dart';
import 'package:kwexpress/app/sign_in/phone_number/subtitle_widget.dart';
import 'package:kwexpress/common_widgets/form_submit_button.dart';
import 'package:kwexpress/common_widgets/platform_alert_dialog.dart';
import 'package:kwexpress/common_widgets/platform_exception_alert_dialog.dart';
import 'package:kwexpress/constants/assets_path.dart';
import 'package:kwexpress/constants/size_config.dart';
import 'package:kwexpress/constants/strings.dart';
import 'package:kwexpress/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PhoneNumberSignInPage extends StatefulWidget {
  const PhoneNumberSignInPage._({Key key, @required this.model})
      : super(key: key);
  final PhoneNumberSignInModel model;

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
    return ChangeNotifierProvider<PhoneNumberSignInModel>(
      create: (_) => PhoneNumberSignInModel(auth: auth),
      child: Consumer<PhoneNumberSignInModel>(
        builder: (_, PhoneNumberSignInModel model, __) =>
            PhoneNumberSignInPage._(model: model),
      ),
    );
  }

  @override
  _PhoneNumberSignInPageState createState() => _PhoneNumberSignInPageState();
}

class _PhoneNumberSignInPageState extends State<PhoneNumberSignInPage> {
  final FocusScopeNode _node = FocusScopeNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  PhoneNumberSignInModel get model => widget.model;
  bool _visible = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSignInError(
      PhoneNumberSignInModel model, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: model.errorAlertTitle,
      exception: exception,
    ).show(context);
  }

  Future<void> _submit() async {
    try {
      final bool success = await model.submit();
      if (success) {
        if (model.formType == EmailPasswordSignInFormType.forgotPassword) {
          await PlatformAlertDialog(
            title: Strings.resetLinkSentTitle,
            content: Strings.resetLinkSentMessage,
            defaultActionText: Strings.ok,
          ).show(context);
        } else {
          // if (widget.onSignedIn != null) {
          //   // widget.onSignedIn();
          // }
        }
      }
    } on PlatformException catch (e) {
      _showSignInError(model, e);
    }
  }

  void _emailEditingComplete() {
    if (model.canSubmitEmail) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!model.canSubmitEmail) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  Widget _buildSubmitButton() {
    return ButtonTheme(
      minWidth: SizeConfig.safeBlockHorizontal * 48 - 50,
      height: 50,
      child: OutlineButton(
        child: Text(
          "SUIVANT",
          style: TextStyle(color: Colors.grey[200]),
        ),
        onPressed: () {},
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

  Widget _buildPhoneNumberField() {
    return SizedBox(
      width: SizeConfig.safeBlockHorizontal * 48 + 50,
      child: TextField(
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
        controller: _emailController,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintStyle: TextStyle(color: Colors.grey),
          hintText: 'entrer vos numero',
          errorText: model.emailErrorText,
          enabled: !model.isLoading,
        ),
        autocorrect: false,
        keyboardType: TextInputType.phone,
        keyboardAppearance: Brightness.light,
        onChanged: model.updateEmail,
        onEditingComplete: _emailEditingComplete,
        inputFormatters: <TextInputFormatter>[
          model.emailInputFormatter,
        ],
      ),
    );
  }

  Widget _buildFadingText() {
    return AnimatedOpacity(
      // If the widget is visible, animate to 0.0 (invisible).
      // If the widget is hidden, animate to 1.0 (fully visible).
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 200),
      // The green box must be a child of the AnimatedOpacity widget.
      child: Text('subtitle'),
    );
  }

  Widget _buildContent() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: SizeConfig.safeBlockVertical * 19,
            width: SizeConfig.safeBlockHorizontal * 48,
            child: Container(
              color: Colors.yellow,
              child: SvgPicture.asset(
                AssetsPath.logo,
                semanticsLabel: 'logo',
              ),
            ),
          ),
          SizedBox(height: 30),
          SubtitleWidget(),
          SizedBox(height: 30),
          _buildPhoneNumberField(),
          SizedBox(height: 30),
          _buildSubmitButton(),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: BoxFit.fill,
              child: SvgPicture.asset(
                AssetsPath.signInBackground,
                semanticsLabel: 'background',
              ),
            ),
            _buildContent(),
          ],
        ),
      ),
    );
  }
}
