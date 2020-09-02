import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kwexpress/app/models/food.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/app/models/restaurant_menu_header.dart';
import 'package:kwexpress/services/api.dart';
import 'package:tuple/tuple.dart';

class APIService {
  APIService({this.api});
  final API api;

  Future<Tuple2<List<Restaurant>, List<String>>> fetchRestaurants() async {
    final uri = api.endpointUri(Endpoint.restaurants);

    await Future.delayed(Duration(milliseconds: 500));
    final response = await http.post(
      uri,
    );

    if (response.statusCode == 200) {
      final LinkedHashMap<String, dynamic> decodedReponse =
          json.decode(response.body);
      final List<dynamic> dataList = decodedReponse['data'];
      final List<dynamic> dataList2 = decodedReponse['offre'];
      List<Restaurant> restaurantsList;
      List<String> offersList;
      if (dataList.isNotEmpty) {
        restaurantsList =
            dataList.map((data) => Restaurant.fromMap(data)).toList();
      }
      if (dataList2.isNotEmpty) {
        offersList = List();

        for (dynamic data in dataList2) {
          offersList.add(data['imgUrl'].toString());
        }
      }
      return Tuple2<List<Restaurant>, List<String>>(
          restaurantsList, offersList);
    }
    throw response;
  }

  Future<Tuple2<List<RestaurantMenuHeader>, List<String>>>
      fetchRestaurantDetail(String restoId) async {
    var url = api.endpointUri(Endpoint.restaurantDetail).toString();
    final params = {'Resto': restoId};

    final response = await http.post(
      url,
      body: params,
    );

    if (response.statusCode == 200) {
      final LinkedHashMap<String, dynamic> decodedReponse =
          json.decode(response.body);

      final List<dynamic> dataList = decodedReponse['data'];

      Iterable imageUrlsTemp = decodedReponse['urls'];

      List<String> imageUrls =
          imageUrlsTemp.map((i) => i['img'].toString()).toList();
      List<RestaurantMenuHeader> restaurantslist = List();
      restaurantslist =
          dataList.map((data) => RestaurantMenuHeader.fromMap(data)).toList();

      final result = Tuple2<List<RestaurantMenuHeader>, List<String>>(
        restaurantslist,
        imageUrls,
      );
      return result;
    }

    throw response;
  }

  Future<List<Food>> fetchMenu(String restoId, String headerId) async {
    String url = api.endpointUri(Endpoint.menu).toString();
    final params = {'Resto': restoId, 'Speciality': headerId};

    final response = await http.post(
      url,
      body: params,
    );

    if (response.statusCode == 200) {
      final LinkedHashMap<String, dynamic> decodedReponse =
          json.decode(response.body);
      ;
      final List<dynamic> dataList = decodedReponse['data'];
      if (dataList.isNotEmpty) {
        final List<Food> list =
            dataList.map((data) => Food.fromMap(data)).toList();
        if (list != null) return list;
      }
    }

    throw response;
  }

  Future<void> updateVue(String restoId) async {
    String url = api.endpointUri(Endpoint.updateVue).toString();
    final params = {'id_resto': restoId};

    await http.post(
      url,
      body: params,
    );
  }

  Future<void> sendMessage(
    String nomFeed,
    String numeroClient,
    String description,
  ) async {
    String url = api.endpointUri(Endpoint.sendMessage).toString();
    final params = {
      'nom_feed': nomFeed,
      'numero_client': numeroClient,
      'description': description,
    };

    await http.post(
      url,
      body: params,
    );
  }
}
