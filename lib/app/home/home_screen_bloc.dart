import 'package:flutter/services.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:location/location.dart';
import 'package:tuple/tuple.dart';

class HomeScreenBloc {
  HomeScreenBloc({this.apiService});
  final APIService apiService;

  Future<Tuple2<List<Restaurant>, List<String>>> fetchRestaurants() async {
    Tuple2<List<Restaurant>, List<String>> t =
        await apiService.fetchRestaurants();

    return t;
  }

  Future<LocationData> getUserPosition() async {
    Location location = Location();
    PermissionStatus _permissionGranted;
    print('getiing user position');

    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw PlatformException(
          code: '1',
          message: 'user refuse to enable gps',
        );
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.deniedForever) {
      print('3lah ah rabak 3lah');
    } else if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw PlatformException(
          code: '2',
          message: 'user refuse to give permission',
        );
      }
      return await location.getLocation();
    }
  }
}
