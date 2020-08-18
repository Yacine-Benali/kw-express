import 'package:flutter/foundation.dart';

class RestaurantMenuHeaders {
  RestaurantMenuHeaders({
    @required this.name,
    @required this.id,
  });
  String name;
  String id;
  factory RestaurantMenuHeaders.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    String name = data['nom_speciality'];
    String id = data['id_speciality'];
    return RestaurantMenuHeaders(
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
