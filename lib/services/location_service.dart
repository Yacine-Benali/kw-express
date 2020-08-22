import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _locationService = LocationService._internal();

  factory LocationService() {
    return _locationService;
  }

  LocationService._internal();

  Position position;

  String getGoogleMapsUrl() {
    if (position == null)
      return 'position unavailable';
    else
      return "https://www.google.com/maps/search/?api=1&query=${position.longitude},${position.latitude}";
  }
}
