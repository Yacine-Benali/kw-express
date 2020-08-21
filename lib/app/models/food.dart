import 'package:flutter/foundation.dart';
import 'package:kwexpress/app/models/restaurant_menu_header.dart';

class Food {
  Food({
    @required this.name,
    @required this.info,
    @required this.price,
    @required this.header,
  });
  String name;
  String info;
  String price;
  //local property
  RestaurantMenuHeader header;

  factory Food.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    String name = data['nom'];
    String info = data['info'];
    String price = data['prix'];
    return Food(
      name: name,
      info: info,
      price: price,
      header: null,
    );
  }

  // @override
  // String toString() {
  //   print('restaurant $name, $id, $address');
  //   return super.toString();
  // }
}
