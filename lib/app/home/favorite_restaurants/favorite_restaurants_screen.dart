import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kwexpress/app/home/favorite_restaurants/favorite_restaurants_bloc.dart';
import 'package:kwexpress/app/home/restaurants/restaurant_tile_widget.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/common_widgets/empty_content.dart';
import 'package:kwexpress/constants/assets_path.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:kwexpress/services/local_storage_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRestaurantsScreen extends StatefulWidget {
  @override
  _FavoriteRestaurantsScreenState createState() =>
      _FavoriteRestaurantsScreenState();
}

class _FavoriteRestaurantsScreenState extends State<FavoriteRestaurantsScreen> {
  FavoriteRestaurantsBloc bloc;
  Future<List<Restaurant>> restaurantsListFuture;
  Future<SharedPreferences> sharedPrefrencesFuture;

  @override
  void initState() {
    APIService api = Provider.of<APIService>(context, listen: false);
    bloc = FavoriteRestaurantsBloc(apiService: api);
    sharedPrefrencesFuture = SharedPreferences.getInstance();
    restaurantsListFuture = bloc.fetchRestaurants();
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
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([restaurantsListFuture, sharedPrefrencesFuture]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            final List<Restaurant> items = snapshot.data[0];
            final SharedPreferences pref = snapshot.data[1];
            if (items.isNotEmpty) {
              return _buildList(items, pref);
            } else {
              return Container();
            }
          } else if (snapshot.hasError) {
            return EmptyContent(
              title: 'Something went wrong',
              message: 'Can\'t load items right now',
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
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
