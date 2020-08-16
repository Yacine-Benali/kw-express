import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/services/api.dart';

class APIService {
  APIService({this.api});
  final API api;

  Future<List<Restaurant>> fetchRestaurants({
    @required Endpoint endpoint,
  }) async {
    final uri = api.endpointUri(endpoint);
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
}
