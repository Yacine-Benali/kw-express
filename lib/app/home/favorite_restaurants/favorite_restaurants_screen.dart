import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kwexpress/app/home/favorite_restaurants/favorite_restaurants_bloc.dart';
import 'package:kwexpress/app/home/restaurants/restaurant_tile_widget.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/constants/assets_path.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:kwexpress/services/local_storage_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRestaurantsScreen extends StatefulWidget {
  const FavoriteRestaurantsScreen({
    Key key,
    @required this.restaurantsList,
    @required this.pref,
  }) : super(key: key);

  final List<Restaurant> restaurantsList;
  final SharedPreferences pref;
  @override
  _FavoriteRestaurantsScreenState createState() =>
      _FavoriteRestaurantsScreenState();
}

class _FavoriteRestaurantsScreenState extends State<FavoriteRestaurantsScreen> {
  FavoriteRestaurantsBloc bloc;
  List<Restaurant> restaurantsList;
  SharedPreferences pref;

  @override
  void initState() {
    APIService api = Provider.of<APIService>(context, listen: false);
    bloc = FavoriteRestaurantsBloc(apiService: api);
    restaurantsList = widget.restaurantsList;
    pref = widget.pref;
    restaurantsList = bloc.fetchRestaurants(pref, restaurantsList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Mes Restaurants Favoris',
            style: TextStyle(color: Colors.grey)),
      ),
      body: _buildList(restaurantsList, pref),
    );
  }

  Widget _buildList(List<Restaurant> items, SharedPreferences pref) {
    LocalStorageService localStorageService = LocalStorageService(perfs: pref);
    final SvgPicture imageProfile = SvgPicture.asset(AssetsPath.imageProfile);
    final SvgPicture imageCover = SvgPicture.asset(AssetsPath.imageCover);
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return RestaurantTileWidget(
          key: UniqueKey(),
          restaurant: items[index],
          imageCover: imageCover,
          imageProfile: imageProfile,
          localStorageService: localStorageService,
        );
      },
    );
  }
}
