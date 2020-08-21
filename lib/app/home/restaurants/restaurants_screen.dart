import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kwexpress/app/home/restaurants/restaurant_tile_widget.dart';
import 'package:kwexpress/app/home/restaurants/restaurants_bloc.dart';
import 'package:kwexpress/app/home/restaurants/swiper_widget.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/common_widgets/empty_content.dart';
import 'package:kwexpress/constants/assets_path.dart';
import 'package:kwexpress/constants/size_config.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:kwexpress/services/auth.dart';
import 'package:kwexpress/services/local_storage_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantsScreen extends StatefulWidget {
  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  RestaurantsBloc bloc;
  Future<List<Restaurant>> restaurantsListFuture;
  Future<SharedPreferences> sharedPrefrencesFuture;
  int _current;

  @override
  void initState() {
    APIService api = Provider.of<APIService>(context, listen: false);
    bloc = RestaurantsBloc(apiService: api);
    sharedPrefrencesFuture = SharedPreferences.getInstance();
    restaurantsListFuture = bloc.fetchRestaurants();
    _current = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([restaurantsListFuture, sharedPrefrencesFuture]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          final List<Restaurant> items = snapshot.data[0];
          final SharedPreferences pref = snapshot.data[1];
          final List<String> urlsList = bloc.getScrollingCoversUrls(items);
          if (items.isNotEmpty) {
            return Column(
              children: [
                Container(
                  color: Colors.white,
                  // child: _buildCarousel(urlsList),
                  child: SwiperWidget(urls: urlsList),
                ),
                Expanded(
                  flex: 5,
                  child: _buildList(items, pref),
                ),
              ],
            );
          } else {
            return EmptyContent(
              title: 'title',
              message: 'message',
            );
          }
        } else if (snapshot.hasError) {
          return EmptyContent(
            title: 'Something went wrong',
            message: 'Can\'t load items right now',
          );
        }
        return Center(child: CircularProgressIndicator());
      },
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
