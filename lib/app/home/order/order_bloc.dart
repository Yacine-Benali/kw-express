import 'package:kwexpress/app/models/food.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/services/location_service.dart';
import 'package:location/location.dart';
import 'package:tuple/tuple.dart';

class OrderBloc {
  OrderBloc({this.restaurant});
  final Restaurant restaurant;

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

  int calculateFoodPrice(List<Food> cartFoodList) {
    int foodPrice = 0;
    for (Food food in cartFoodList) foodPrice += int.parse(food.price);
    return foodPrice;
  }

  bool _checkSameFood(Food food1, Food food2) {
    return food1.name == food2.name &&
        food1.info == food2.info &&
        food1.price == food2.price;
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
}
