import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kwexpress/app/home/restaurants/restaurant_tile_widget.dart';
import 'package:kwexpress/app/home/restaurants/restaurants_bloc.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/common_widgets/empty_content.dart';
import 'package:kwexpress/constants/assets_path.dart';
import 'package:kwexpress/constants/size_config.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:kwexpress/services/auth.dart';
import 'package:provider/provider.dart';

class RestaurantsScreen extends StatefulWidget {
  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  RestaurantsBloc bloc;
  Future<List<Restaurant>> restaurantsListFuture;

  @override
  void initState() {
    APIService api = Provider.of<APIService>(context, listen: false);
    bloc = RestaurantsBloc(apiService: api);
    restaurantsListFuture = bloc.fetchRestaurants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Restaurant>>(
      future: restaurantsListFuture,
      builder:
          (BuildContext context, AsyncSnapshot<List<Restaurant>> snapshot) {
        if (snapshot.hasData) {
          final List<Restaurant> items = snapshot.data;
          if (items.isNotEmpty) {
            return _buildList(items);
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

  Widget _buildList(List<Restaurant> items) {
    //return RestaurantTileWidget();

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
        );
      },
    );
    // return new Container(
    //   width: SizeConfig.screenWidth,
    //   height: double.infinity,
    //   child: verticalList,
    // );
  }
}
