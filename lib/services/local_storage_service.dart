import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService({@required this.perfs});
  final SharedPreferences perfs;

  Future<bool> _saveList(List<String> list) async {
    return await perfs.setStringList('favoriteRestaurants', list);
  }

  List<String> getFavoriteRestaurants() {
    return perfs.getStringList('favoriteRestaurants');
  }

  Future<void> addToFavorite(String restaurantId) async {
    List<String> favoriteRestaurants = List();
    List<String> list = getFavoriteRestaurants();
    if (list != null) favoriteRestaurants.addAll(list);
    favoriteRestaurants.add(restaurantId);
    await _saveList(favoriteRestaurants);
    // print('*****');
    // print('request to add $restaurantId');
    // print('past: $list');
    // print('current $favoriteRestaurants');
  }

  Future<void> removeFromFavorite(String restaurantId) async {
    List<String> favoriteRestaurants = List();
    List<String> list = getFavoriteRestaurants();
    if (list != null) {
      for (String restoId in list)
        if (restoId != restaurantId) {
          favoriteRestaurants.add(restoId);
        }
    }
    _saveList(favoriteRestaurants);
    // print('*****');
    // print('request to remvoe $restaurantId');
    // print('past: $list');
    // print('current $favoriteRestaurants');
  }
}
