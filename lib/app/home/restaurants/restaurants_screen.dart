import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kwexpress/app/home/restaurants/restaurant_tile_widget.dart';
import 'package:kwexpress/app/home/restaurants/restaurants_bloc.dart';
import 'package:kwexpress/app/home/restaurants/swiper_widget.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/common_packages/pk_search_bar/pk_search_bar.dart';
import 'package:kwexpress/common_packages/pk_search_bar/search_bar_style.dart';
import 'package:kwexpress/constants/assets_path.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:kwexpress/services/local_storage_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({
    Key key,
    @required this.restaurantsList,
    @required this.pref,
  }) : super(key: key);

  final List<Restaurant> restaurantsList;
  final SharedPreferences pref;

  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  RestaurantsBloc bloc;
  List<String> urlsList;
  List<Restaurant> restaurantsWithFav;

  @override
  void initState() {
    APIService api = Provider.of<APIService>(context, listen: false);
    bloc = RestaurantsBloc(apiService: api);
    urlsList = bloc.getScrollingCoversUrls(widget.restaurantsList);
    restaurantsWithFav =
        bloc.fetchRestaurantWithFavorites(widget.restaurantsList, widget.pref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: SwiperWidget(urls: urlsList),
        ),
        Expanded(
          flex: 5,
          child: _buildList(
            restaurantsWithFav,
            widget.pref,
          ),
        ),
      ],
    );
  }

  Widget _buildList(List<Restaurant> items, SharedPreferences pref) {
    LocalStorageService localStorageService = LocalStorageService(perfs: pref);
    final SvgPicture imageProfile = SvgPicture.asset(AssetsPath.imageProfile);
    final SvgPicture imageCover = SvgPicture.asset(AssetsPath.imageCover);

    return SearchBar<Restaurant>(
      searchBarStyle: SearchBarStyle(padding: EdgeInsets.all(0)),
      searchBarPadding: EdgeInsets.only(right: 8, left: 8),
      listPadding: EdgeInsets.only(left: 0, right: 0),
      icon: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Icon(Icons.search),
      ),
      hintText: "Chercher un restaurant",
      cancellationWidget: Text('Annuler'),
      hintStyle: TextStyle(
        color: Colors.black54,
      ),
      textStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      iconActiveColor: Colors.red,
      shrinkWrap: true,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      suggestions: items,
      minimumChars: 1,
      emptyWidget: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Text("aucun restaurant trouvé"),
        ),
      ),
      onError: (error) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text("$error", textAlign: TextAlign.center),
          ),
        );
      },
      onSearch: (r) async => bloc.getResetaurantSearch(items, r),
      buildSuggestion: (Restaurant restaurant, int index) {
        if (index == items.length - 1) {
          return Column(
            children: [
              RestaurantTileWidget(
                key: UniqueKey(),
                restaurant: restaurant,
                imageCover: imageCover,
                imageProfile: imageProfile,
                localStorageService: localStorageService,
              ),
              SizedBox(height: 75),
            ],
          );
        }
        return RestaurantTileWidget(
          key: UniqueKey(),
          restaurant: restaurant,
          imageCover: imageCover,
          imageProfile: imageProfile,
          localStorageService: localStorageService,
        );
      },
      onItemFound: (Restaurant restaurant, int index) {
        return RestaurantTileWidget(
          key: UniqueKey(),
          restaurant: restaurant,
          imageCover: imageCover,
          imageProfile: imageProfile,
          localStorageService: localStorageService,
        );
      },
    );
  }
}
