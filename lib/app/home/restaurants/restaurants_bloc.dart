import 'package:kwexpress/app/models/menu_page.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/services/api.dart';
import 'package:kwexpress/services/api_service.dart';

class RestaurantsBloc {
  RestaurantsBloc({this.apiService});
  final APIService apiService;
  Future<List<Restaurant>> fetchRestaurants() async {
    return await apiService.fetchRestaurants();
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
