import 'package:flutter/foundation.dart';
import 'package:kwexpress/app/models/food.dart';
import 'package:kwexpress/app/models/restaurant_menu_headers.dart';

class MenuPage {
  MenuPage({
    @required this.header,
    @required this.foods,
  });

  final RestaurantMenuHeaders header;
  final List<Food> foods;
}
