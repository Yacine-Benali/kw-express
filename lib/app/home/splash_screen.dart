import 'package:flutter/material.dart';
import 'package:kwexpress/app/sign_in/phone_number/subtitle_widget.dart';
import 'package:kwexpress/constants/assets_path.dart';
import 'package:kwexpress/constants/size_config.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // Timer(
    //   Duration(seconds: 4),
    //   () => Navigator.of(context, rootNavigator: false).push(
    //     MaterialPageRoute(
    //       builder: (context) => LandingPage(),
    //       fullscreenDialog: true,
    //     ),
    //   ),
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 19,
                    width: SizeConfig.safeBlockHorizontal * 48,
                    child: Image.asset(AssetsPath.logo),
                  ),
                  SizedBox(height: 30),
                  SubtitleWidget(),
                  SizedBox(height: 30),
                  SizedBox(height: 30),
                  SizedBox(height: 30),
                  SizedBox(height: 50),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
