import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:kwexpress/app/models/food.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/app/models/restaurant_menu_headers.dart';
import 'package:kwexpress/services/api.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

class APIService {
  APIService({this.api});
  final API api;
  DioCacheManager _dioCacheManager = DioCacheManager(
      CacheConfig(baseUrl: 'http://fahemnydz.000webhostapp.com'));
  Options _cacheOptions =
      buildCacheOptions(Duration(days: 7), forceRefresh: false);
  Dio _dio = Dio();
  //
  Future<List<Restaurant>> fetchRestaurants() async {
    final uri = api.endpointUri(Endpoint.restaurants);

    _dio.interceptors.add(_dioCacheManager.interceptor);

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

    throw response;
  }

  Future<Tuple2<List<RestaurantMenuHeaders>, List<String>>>
      fetchRestaurantDetail(String restoId) async {
    var url = api.endpointUri(Endpoint.restaurantDetail).toString();
    final params = {'Resto': restoId};
    FormData formData = FormData.fromMap(params);
    _dio.interceptors.add(_dioCacheManager.interceptor);

    final response = await _dio.post(
      url,
      options: _cacheOptions,
      data: formData,
    );

    if (response.statusCode == 200) {
      final LinkedHashMap<String, dynamic> decodedReponse = response.data;
      print(response.data);
      final List<dynamic> dataList = decodedReponse['data'];
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
        return result;
      }
    }

    throw response;
  }

  Future<List<Food>> fetchMenu(String restoId, String headerId) async {
    String url = api.endpointUri(Endpoint.menu).toString();
    final params = {'Resto': restoId, 'Speciality': headerId};

    FormData formData = FormData.fromMap(params);
    _dio.interceptors.add(_dioCacheManager.interceptor);

    final response = await _dio.post(
      url,
      options: _cacheOptions,
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

    throw response;
  }
}