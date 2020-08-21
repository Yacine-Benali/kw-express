import 'package:flutter/foundation.dart';

class Restaurant {
  Restaurant({
    @required this.id,
    @required this.name,
    @required this.location,
    @required this.address,
    @required this.wilaya,
    @required this.time,
    @required this.imageCover,
    @required this.imageProfile,
    @required this.offre,
    @required this.service,
    @required this.workingHours,
    @required this.description,
    @required this.phoneNumber,
    @required this.visible,
    @required this.seen,
    @required this.isFavorit,
  });
  String id;
  String name;
  String location;
  String address;
  String wilaya;
  String time;
  String imageCover;
  String imageProfile;
  String offre;
  String service;
  String workingHours;
  String description;
  String phoneNumber;
  String visible;
  String seen;
  // local property
  bool isFavorit;

  factory Restaurant.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    String id = data['id_resto'];
    String name = data['nom_resto'];
    String location = data['map'];
    String address = data['adress'];
    String wilaya = data['wilaya'];
    String time = data['dure'];
    String imageCover = data['img_cover'];
    String imageProfile = data['img_profile'];
    String offre = data['offre'];
    String service = data['service'];
    String workingHours = data['horaires'];
    String description = data['description'];
    String phoneNumber = data['num_tel'];
    String visible = data['visible'];
    String seen = data['vue'];

    return Restaurant(
      id: id,
      name: name,
      location: location,
      address: address,
      wilaya: wilaya,
      time: time,
      imageCover: imageCover,
      imageProfile: imageProfile,
      offre: offre,
      service: service,
      workingHours: workingHours,
      description: description,
      phoneNumber: phoneNumber,
      visible: visible,
      seen: seen,
      // default
      isFavorit: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'address': address,
      'wilaya': wilaya,
      'time': time,
      'imageCover': imageCover,
      'imageProfile': imageProfile,
      'offre': offre,
      'service': service,
      'workingHours': workingHours,
      'description': description,
      'phoneNumber': phoneNumber,
      'visible': visible,
      'seen': seen,
    };
  }

  @override
  String toString() {
    print('restaurant $name, $id, $address');
    return super.toString();
  }
}
