import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kwexpress/app/landing_page.dart';
import 'package:kwexpress/constants/app_colors.dart';
import 'package:kwexpress/services/api.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:kwexpress/services/auth.dart';
import 'package:kwexpress/services/firebase_auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.colorPrimary,
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
            primarySwatch: Colors.red,
          ),
          home: LandingPage(),
        ),
      ),
    );
  }
}
