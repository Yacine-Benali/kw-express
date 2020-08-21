import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kwexpress/app/home/restaurants/restaurants_screen.dart';
import 'package:kwexpress/common_widgets/custom_icons_icons.dart';
import 'package:kwexpress/common_widgets/platform_exception_alert_dialog.dart';
import 'package:kwexpress/services/location_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Widget> _pagesList;

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
    getCurrentLocation();
    _pagesList = [
      RestaurantsScreen(),
      Container(color: Colors.white),
      Container(color: Colors.yellow),
      Container(color: Colors.green),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    color: _currentIndex == 0 ? Colors.red : Colors.grey,
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
                    color: _currentIndex == 1 ? Colors.red : Colors.grey,
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
                    color: _currentIndex == 2 ? Colors.red : Colors.grey,
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
                    color: _currentIndex == 3 ? Colors.red : Colors.grey,
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
