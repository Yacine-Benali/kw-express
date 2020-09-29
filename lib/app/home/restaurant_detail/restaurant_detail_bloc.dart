import 'package:flutter/foundation.dart';
import 'package:kwexpress/app/models/food.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/app/models/restaurant_menu_header.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:kwexpress/services/location_service.dart';
import 'package:location/location.dart';
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
      final Tuple2<List<RestaurantMenuHeader>, List<String>> t1 =
          await apiService.fetchRestaurantDetail(restaurant.id);
      return t1.item1;
    } on Exception catch (e) {
      print(e);
    }
  }

  List<String> getUrls(RestaurantMenuHeader header) {
    return this.urls;
  }

  Future<List<Food>> fetchFoods(RestaurantMenuHeader header) async {
    print('fetching food');
    try {
      List<Food> foods = await apiService.fetchMenu(restaurant.id, header.id);
      foods.forEach((element) => element.header = header);
      return foods;
    } on Exception catch (e) {
      print(e);
    }
  }

  List<Tuple2<Food, int>> getSortedOrder(List<Food> cartFoodList) {
    List<Tuple2<Food, int>> sortedOrder = List();
    List<Food> sortedFoods = List();

    for (Food food in cartFoodList) {
      bool isSorted =
          sortedFoods.any((sortedFood) => _checkSameFood(food, sortedFood));
      if (!isSorted) {
        int repetition = cartFoodList
            .where((element) => _checkSameFood(food, element))
            .length;
        Tuple2 temp = Tuple2<Food, int>(food, repetition);
        sortedOrder.add(temp);
        sortedFoods.add(food);
      }
    }
    return sortedOrder;
  }

  bool _checkSameFood(Food food1, Food food2) {
    return food1.name == food2.name &&
        food1.info == food2.info &&
        food1.price == food2.price;
  }

  int calculateFoodPrice(List<Food> cartFoodList) {
    int foodPrice = 0;
    for (Food food in cartFoodList) foodPrice += int.parse(food.price);
    return foodPrice;
  }

  Future<String> createMessage(
      List<Tuple2<Food, int>> sortedOrder, int fullPrice) async {
    try {
      LocationService locationService = LocationService();

      LocationData locationData = await locationService.getUserPosition();
      //print(locationData.latitude);
      String userLocation = locationService.getGoogleMapsUrl(locationData);
      String restaurant = 'Restaurant:' + this.restaurant.name;
      String delivery = 'Livraison: \n' + userLocation ?? 'not available';
      String sfullPrice = 'Somme: ' + fullPrice.toString() + ' DA';

      String foodDescription = '';
      for (Tuple2<Food, int> tuple in sortedOrder) {
        Food food = tuple.item1;
        int repetition = tuple.item2;
        String temp =
            repetition.toString() + ' * ${food.header.name} - ${food.name}';
        foodDescription = foodDescription + temp + '\n';
      }

      String orderMessage = restaurant +
          '\n\n' +
          delivery +
          '\n\n' +
          sfullPrice +
          '\n\n' +
          foodDescription +
          '\n';

      return orderMessage;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateVue() async {
    try {
      await apiService.updateVue(restaurant.id);
    } catch (e) {
      print(e);
    }
  }
}
