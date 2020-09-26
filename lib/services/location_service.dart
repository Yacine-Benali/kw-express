class LocationService {
  static final LocationService _locationService = LocationService._internal();

  factory LocationService() {
    return _locationService;
  }

  LocationService._internal();

  // Position position;

  String getGoogleMapsUrl() {
    return "https://www.google.com/maps/search/?api=1&query=0,0";
  }
}
