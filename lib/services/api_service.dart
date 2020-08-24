import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:kwexpress/app/models/food.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/app/models/restaurant_menu_header.dart';
import 'package:kwexpress/services/api.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;

class APIService {
  APIService({this.api});
  final API api;
  DioCacheManager _dioCacheManager = DioCacheManager(
      CacheConfig(baseUrl: 'https://fahemnydz.000webhostapp.com'));
  Options _cacheOptions = buildCacheOptions(
    Duration(days: 7),
    forceRefresh: false,
    maxStale: Duration(days: 7),
    options: Options(
      responseType: ResponseType.json,
    ),
  );
  Dio _dio = Dio();
  //
  Future<List<Restaurant>> fetchRestaurants() async {
    final uri = api.endpointUri(Endpoint.restaurants);

    _dio.interceptors.add(_dioCacheManager.interceptor);
    try {
      final response = await _dio.post(
        uri.toString(),
        options: _cacheOptions,
      );

      if (response.statusCode == 200) {
        final LinkedHashMap<String, dynamic> decodedReponse = response.data;
        final List<dynamic> dataList = decodedReponse['data'];
        if (dataList.isNotEmpty) {
          final List<Restaurant> list =
              dataList.map((data) => Restaurant.fromMap(data)).toList();
          if (list != null) return list;
        }
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<String>> fetchSpecialoffer() async {
    final uri = api.endpointUri(Endpoint.restaurants);

    _dio.interceptors.add(_dioCacheManager.interceptor);

    final response = await _dio.post(
      uri.toString(),
      options: _cacheOptions,
    );

    if (response.statusCode == 200) {
      final LinkedHashMap<String, dynamic> decodedReponse = response.data;
      final List<dynamic> dataList = decodedReponse['offre'];
      print(dataList);
      if (dataList.isNotEmpty) {
        final List<String> list = List();

        for (dynamic data in dataList) {
          list.add(data['imgUrl'].toString());
        }
        if (list != null) return list;
      }
    }

    throw response;
  }

  Future<Tuple2<List<RestaurantMenuHeader>, List<String>>>
      fetchRestaurantDetail(String restoId) async {
    print('fetching for $restoId');
    // Options _cacheOptions2 = buildCacheOptions(
    //   Duration(days: 7),
    //   subKey: restoId,
    //   forceRefresh: true,
    //   maxStale: Duration(days: 7),
    //   options: Options(
    //     responseType: ResponseType.json,
    //   ),
    // );
    var url = api.endpointUri(Endpoint.restaurantDetail).toString();
    final params = {'Resto': restoId};
    FormData formData = FormData.fromMap(params);
    // _dio.interceptors.add(_dioCacheManager.interceptor);

    try {
      // final response = await http.post(
      //   url,
      //   body: params,
      // );
      final Response response = await _dio.post(
        url,
        // options: _cacheOptions2,
        data: formData,
      );
      if (response.statusCode == 200) {
        final LinkedHashMap<String, dynamic> decodedReponse = response.data;
        // json.decode(response.body);

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
    } catch (e) {
      throw e;
    }
  }

  Future<List<Food>> fetchMenu(String restoId, String headerId) async {
    // Options _cacheOptions2 = buildCacheOptions(
    //   Duration(days: 7),
    //   forceRefresh: true,
    //   subKey: '$restoId-$headerId',
    //   maxStale: Duration(days: 7),
    //   options: Options(
    //     responseType: ResponseType.json,
    //   ),
    // );
    String url = api.endpointUri(Endpoint.menu).toString();
    final params = {'Resto': restoId, 'Speciality': headerId};

    FormData formData = FormData.fromMap(params);
    // _dio.interceptors.add(_dioCacheManager.interceptor);

    try {
      final response = await _dio.post(
        url,
        // options: _cacheOptions2,
        data: formData,
      );

      if (response.statusCode == 200) {
        final LinkedHashMap<String, dynamic> decodedReponse = response.data;
        final List<dynamic> dataList = decodedReponse['data'];
        if (dataList.isNotEmpty) {
          final List<Food> list =
              dataList.map((data) => Food.fromMap(data)).toList();
          if (list != null) return list;
        }
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateVue(String restoId) async {
    String url = api.endpointUri(Endpoint.updateVue).toString();
    final params = {'id_resto': restoId};

    FormData formData = FormData.fromMap(params);

    await _dio.post(url, data: formData);
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

    FormData formData = FormData.fromMap(params);

    await _dio.post(url, data: formData);
  }
}
