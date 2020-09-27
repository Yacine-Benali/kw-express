import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationService {
  static final LocationService _locationService = LocationService._internal();

  factory LocationService() {
    return _locationService;
  }
  LocationService._internal();

  Future<LocationData> getUserPosition() async {
    Location location = Location();
    PermissionStatus _permissionGranted;
    LocationData locationData;

    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      print('gps not enabled');
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw PlatformException(
          code: '1',
          message:
              "vous avez refusé d'autoriser l'accès GPS à cette application, mais vous devez l'activer pour passer une commande",
        );
      }
    }
    _permissionGranted = await location.hasPermission();
    print(_permissionGranted);
    if (_permissionGranted == PermissionStatus.deniedForever) {
      print('3lah ah rabak 3lah');
      throw PlatformException(
        code: '2',
        message:
            "vous avez définitivement refusé à cette application l'accès à votre emplacement, veuillez l'activer dans les paramètres",
      );
    } else if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw PlatformException(
          code: '1',
          message:
              "vous avez refusé d'autoriser l'accès GPS à cette application, mais vous devez l'activer pour passer une commande",
        );
      }
    }
    locationData = await location.getLocation();
    return locationData;
  }

  String getGoogleMapsUrl(LocationData locationData) {
    if (locationData == null)
      return 'position unavailable';
    else
      return "https://www.google.com/maps/search/?api=1&query=${locationData.longitude},${locationData.latitude}";
  }
}
