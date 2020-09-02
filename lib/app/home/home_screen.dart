import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kwexpress/app/home/favorite_restaurants/favorite_restaurants_screen.dart';
import 'package:kwexpress/app/home/offers/offer_screen.dart';
import 'package:kwexpress/app/home/restaurants/restaurants_screen.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/common_widgets/custom_icons_icons.dart';
import 'package:kwexpress/common_widgets/platform_exception_alert_dialog.dart';
import 'package:kwexpress/constants/app_colors.dart';
import 'package:kwexpress/constants/size_config.dart';
import 'package:kwexpress/services/firebase_messaging_service.dart';
import 'package:kwexpress/services/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

import 'client_space/client_space_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
    @required this.apiResponse,
    @required this.pref,
  }) : super(key: key);

  final Tuple2<List<Restaurant>, List<String>> apiResponse;
  final SharedPreferences pref;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Widget> _pagesList;
  List<Restaurant> restaurantsList;
  List<String> specialOffer;
  SharedPreferences sharedPrefrences;

  Future<void> getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    LocationService locationService = LocationService();

    try {
      Position position = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      locationService.position = position;
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'error getting location',
        exception: e,
      ).show(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    FirebaseMessagingService firebaseMessagingService =
        FirebaseMessagingService();
    firebaseMessagingService.configFirebaseNotification();

    getCurrentLocation();
    Tuple2<List<Restaurant>, List<String>> t = widget.apiResponse;
    restaurantsList = t.item1;
    specialOffer = t.item2;
    sharedPrefrences = widget.pref;
    _pagesList = [
      RestaurantsScreen(
        pref: sharedPrefrences,
        restaurantsList: restaurantsList,
      ),
      FavoriteRestaurantsScreen(
        pref: sharedPrefrences,
        restaurantsList: restaurantsList,
      ),
      OfferScreen(
        restaurantsList: restaurantsList,
        specialOffersList: specialOffer,
      ),
      ClientSpaceScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return SafeArea(
      child: Scaffold(
        body: _pagesList[_currentIndex],
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
                child: IconButton(
                  icon: Icon(
                    CustomIcons.restaurant,
                    size: 28,
                    color: _currentIndex == 0
                        ? AppColors.colorPrimary
                        : Colors.grey,
                  ),
                  onPressed: () => setState(() {
                    _currentIndex = 0;
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: IconButton(
                  icon: Icon(
                    CustomIcons.favoris,
                    size: 28,
                    color: _currentIndex == 1
                        ? AppColors.colorPrimary
                        : Colors.grey,
                  ),
                  onPressed: () => setState(() {
                    _currentIndex = 1;
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: IconButton(
                  icon: Icon(
                    CustomIcons.offre,
                    size: 28,
                    color: _currentIndex == 2
                        ? AppColors.colorPrimary
                        : Colors.grey,
                  ),
                  onPressed: () => setState(() {
                    _currentIndex = 2;
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: IconButton(
                  icon: Icon(
                    CustomIcons.client,
                    size: 28,
                    color: _currentIndex == 3
                        ? AppColors.colorPrimary
                        : Colors.grey,
                  ),
                  onPressed: () => setState(() {
                    _currentIndex = 3;
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
