import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/app/models/restaurant_menu_headers.dart';
import 'package:kwexpress/services/api.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:tuple/tuple.dart';

class APIService {
  APIService({this.api});
  final API api;

  Future<List<Restaurant>> fetchRestaurants() async {
    final uri = api.endpointUri(Endpoint.restaurants);
    final response = await http.post(
      uri.toString(),
    );
    if (response.statusCode == 200) {
      final LinkedHashMap<String, dynamic> decodedReponse =
          json.decode(response.body);
      final List<dynamic> dataList = decodedReponse['data'];
      if (dataList.isNotEmpty) {
        final List<Restaurant> list =
            dataList.map((data) => Restaurant.fromMap(data)).toList();
        if (list != null) return list;
      }
    }

    throw response;
  }

  Future<List<RestaurantMenuHeaders>> fetchRestaurantDetail() async {
    var url = api.endpointUri(Endpoint.restaurantDetail).toString();
    const param = {'Resto': '2'};

    final response = await http.post(
      url,
      body: param,
    );

    if (response.statusCode == 200) {
      final LinkedHashMap<String, dynamic> decodedReponse =
          json.decode(response.body);
      //print(response.body);
      final List<dynamic> dataList = decodedReponse['data'];
      print(response.body);

      Iterable list = decodedReponse['urls'];

      List<String> imageUrls = list.map((i) => i['img'].toString()).toList();

      if (dataList.isNotEmpty && imageUrls.isNotEmpty) {
        final List<RestaurantMenuHeaders> list = dataList
            .map((data) => RestaurantMenuHeaders.fromMap(data))
            .toList();
        final result = Tuple2<List<RestaurantMenuHeaders>, List<String>>(
          list,
          imageUrls,
        );
      }
    }

    throw response;
  }

  Future<void> fetchMenu() async {
    print('sending request');
    String url = api.endpointUri(Endpoint.menu).toString();
    print(url);
    const json = {'Resto': '2', 'Speciality': '2'};
    try {
      Response response = await http.post(
        url,
        body: json,
      );
      print(response.body);
    } catch (e) {
      print(e);
    }
  }
}
