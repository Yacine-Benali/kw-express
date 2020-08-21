import 'package:flutter/foundation.dart';

class RestaurantMenuHeader {
  RestaurantMenuHeader({
    @required this.name,
    @required this.id,
  });
  String name;
  String id;
  factory RestaurantMenuHeader.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    String name = data['nom_speciality'];
    String id = data['id_speciality'];
    return RestaurantMenuHeader(
      name: name,
      id: id,
    );
  }

  // @override
  // String toString() {
  //   print('restaurant $name, $id, $address');
  //   return super.toString();
  // }
}
