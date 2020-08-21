import 'package:flutter/foundation.dart';
import 'package:kwexpress/app/models/food.dart';
import 'package:kwexpress/app/models/menu_page.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/app/models/restaurant_menu_headers.dart';
import 'package:kwexpress/services/api.dart';
import 'package:kwexpress/services/api_service.dart';

class RestaurantDetailBloc {
  RestaurantDetailBloc({
    @required this.apiService,
    @required this.restaurant,
  });
  final Restaurant restaurant;
  final APIService apiService;
  List<String> urls;

  Future<List<MenuPage>> fetchMenu() async {
    final t1 = await apiService.fetchRestaurantDetail(restaurant.id);
    List<RestaurantMenuHeaders> headersList = t1.item1;
    List<String> urlsList = t1.item2;
    this.urls = urlsList;
    List<MenuPage> menuPages = List();
    for (RestaurantMenuHeaders header in headersList) {
      List<Food> foods = await apiService.fetchMenu(restaurant.id, header.id);
      menuPages.add(MenuPage(header: header, foods: foods));
    }
    print('done');
    return menuPages;
  }

  List<String> getScrollingCoversUrls(List<Restaurant> list) {
    List<String> coverImageUrlsList = List();

    for (Restaurant restaurant in list) {
      if (restaurant.imageCover != null)
        coverImageUrlsList.add(restaurant.imageCover);
    }
    return coverImageUrlsList;
  }

  List<String> getUrls() {
    return this.urls;
  }
}
