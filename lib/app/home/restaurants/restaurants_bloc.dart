import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/services/api.dart';
import 'package:kwexpress/services/api_service.dart';

class RestaurantsBloc {
  RestaurantsBloc({this.apiService});
  final APIService apiService;

  Future<List<Restaurant>> fetchRestaurants() async =>
      await apiService.fetchRestaurants(endpoint: Endpoint.restaurants);
}
