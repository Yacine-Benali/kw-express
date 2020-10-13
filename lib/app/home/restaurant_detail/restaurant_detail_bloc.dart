import 'package:flutter/foundation.dart';
import 'package:kwexpress/app/models/food.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/app/models/restaurant_menu_header.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:retry/retry.dart';
import 'package:tuple/tuple.dart';

class RestaurantDetailBloc {
  RestaurantDetailBloc({
    @required this.apiService,
    @required this.restaurant,
  });
  final Restaurant restaurant;
  final APIService apiService;
  List<String> urls;

  Future<List<RestaurantMenuHeader>> fetchRestaurantHeader() async {
    try {
      final Tuple2<List<RestaurantMenuHeader>, List<String>> t1 = await retry(
        () => apiService.fetchRestaurantDetail(restaurant.id),
        retryIf: (e) => true,
      );
      return t1.item1;
    } on Exception catch (e) {
      print(e);
    }
  }

  List<String> getUrls(RestaurantMenuHeader header) {
    return this.urls;
  }

  Future<List<Food>> fetchFoods(RestaurantMenuHeader header) async {
    //print('fetching food');
    try {
      List<Food> foods = await retry(
        () => apiService.fetchMenu(restaurant.id, header.id),
        retryIf: (e) => true,
      );
      foods?.forEach((element) => element.header = header);
      return foods;
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> updateVue() async {
    try {
      await apiService.updateVue(restaurant.id);
    } catch (e) {
      print(e);
    }
  }

  String googleToAppleUrl(String googleUrl) {}
}
