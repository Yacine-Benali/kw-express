import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kwexpress/app/home/home_screen.dart';
import 'package:kwexpress/app/home/home_screen_bloc.dart';
import 'package:kwexpress/app/home/splash_screen.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:kwexpress/services/auth.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

import 'sign_in/phone_number/phone_number_sign_in_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Auth auth;
  HomeScreenBloc bloc;
  Future<SharedPreferences> sharedPrefrencesFuture;
  Future<Tuple2<List<Restaurant>, List<String>>> restaurantsListFuture;
  Future<void> getCurrentLocation() async {
    try {
      LocationData locationData = await bloc.getUserPosition();
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            "L'application K&W Express a besoin de cette permission pour son bon fonctionnement",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void initState() {
    APIService api = Provider.of<APIService>(context, listen: false);
    sharedPrefrencesFuture = SharedPreferences.getInstance();
    bloc = HomeScreenBloc(apiService: api);
    restaurantsListFuture = bloc.fetchRestaurants();
    auth = Provider.of<Auth>(context, listen: false);
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthUser>(
      stream: auth.onAuthStateChanged,
      builder: (context, authSnapshot) {
        return FutureBuilder<List<dynamic>>(
          future: Future.wait([restaurantsListFuture, sharedPrefrencesFuture]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              if (authSnapshot.connectionState == ConnectionState.active) {
                AuthUser user = authSnapshot.data;
                if (user == null) {
                  return PhoneNumberSignInPage.create(context);
                }
                return HomeScreen(
                  apiResponse: snapshot.data[0],
                  pref: snapshot.data[1],
                );
              } else {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }
            return SplashScreen();
          },
        );
      },
    );
  }
}
