import 'package:flutter/foundation.dart';

class Food {
  Food({
    @required this.name,
    @required this.info,
    @required this.price,
  });
  String name;
  String info;
  String price;

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
    );
  }

  // @override
  // String toString() {
  //   print('restaurant $name, $id, $address');
  //   return super.toString();
  // }
}
