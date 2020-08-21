import 'package:kwexpress/app/models/menu_page.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/services/api.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:kwexpress/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantsBloc {
  RestaurantsBloc({this.apiService});
  final APIService apiService;
  Future<List<Restaurant>> fetchRestaurants() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    LocalStorageService storageService = LocalStorageService(perfs: pref);
    List<String> favoriteRestaurantIdsList =
        storageService.getFavoriteRestaurants();
    List<Restaurant> temp = await apiService.fetchRestaurants();
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

  List<String> getScrollingCoversUrls(List<Restaurant> list) {
    List<String> coverImageUrlsList = List();

    for (Restaurant restaurant in list) {
      if (restaurant.imageCover != null)
        coverImageUrlsList.add(restaurant.imageCover);
    }
    return coverImageUrlsList;
  }
}
