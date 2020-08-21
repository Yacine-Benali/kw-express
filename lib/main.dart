import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kwexpress/app/landing_page.dart';
import 'package:kwexpress/services/api.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:kwexpress/services/auth.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:kwexpress/services/firebase_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          AppColors.colorPrimary, //or set color with: Color(0xFF0000FF)
    ));
    API api = API();
    return Provider<Auth>(
      create: (context) => FirebaseAuthService(),
      child: Provider<APIService>(
        create: (context) => APIService(api: api),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'kw',
          theme: ThemeData(
            primarySwatch: AppColors.colorPrimary,
          ),
          home: LandingPage(),
        ),
      ),
    );
  }
}
