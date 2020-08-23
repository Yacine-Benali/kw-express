import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:kwexpress/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRestaurantsBloc {
  FavoriteRestaurantsBloc({this.apiService});
  final APIService apiService;
  Future<List<Restaurant>> fetchRestaurants() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    LocalStorageService storageService = LocalStorageService(perfs: pref);
    List<String> favoriteRestaurantIdsList =
        storageService.getFavoriteRestaurants();
    //
    List<Restaurant> temp = await apiService.fetchRestaurants();
    List<Restaurant> favoriteRestaurants = List();
    if (temp != null && favoriteRestaurantIdsList != null) {
      List<Restaurant> restaurantsList = List();
      restaurantsList.addAll(temp);

      for (Restaurant restaurant in restaurantsList) {
        for (String favRestaurantId in favoriteRestaurantIdsList) {
          if (restaurant.id == favRestaurantId) {
            restaurant.isFavorit = true;
            favoriteRestaurants.add(restaurant);
          }
        }
      }
      return favoriteRestaurants;
    }

    return favoriteRestaurants;
  }
}
