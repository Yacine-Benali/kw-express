import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:kwexpress/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantsBloc {
  RestaurantsBloc({this.apiService});
  final APIService apiService;

  List<String> getScrollingCoversUrls(List<Restaurant> list) {
    List<String> coverImageUrlsList = List();

    for (Restaurant restaurant in list) {
      if (restaurant.imageCover != null)
        coverImageUrlsList.add(restaurant.imageCover);
    }
    return coverImageUrlsList;
  }

  List<Restaurant> fetchRestaurantWithFavorites(
    List<Restaurant> temp,
    SharedPreferences pref,
  ) {
    LocalStorageService storageService = LocalStorageService(perfs: pref);
    List<String> favoriteRestaurantIdsList =
        storageService.getFavoriteRestaurants();

    if (temp != null && favoriteRestaurantIdsList != null) {
      List<Restaurant> restaurantsList = List();
      restaurantsList.addAll(temp);

      for (Restaurant restaurant in restaurantsList) {
        for (String favRestaurantId in favoriteRestaurantIdsList) {
          if (restaurant.id == favRestaurantId) {
            restaurant.isFavorit = true;
          }
        }
      }
      return restaurantsList;
    }
    return temp;
  }

  Future<List<Restaurant>> getResetaurantSearch(
      List<Restaurant> items, String search) async {
    if (search == "empty") return [];
    if (search == "error") throw Error();
    List<Restaurant> filteredSearchList = [];

    for (Restaurant s in items) {
      if (s.name.toLowerCase().contains(search.toLowerCase())) {
        filteredSearchList.add(s);
      }
    }
    return filteredSearchList;
  }
}
