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
import 'package:provider/provider.dart';

class RestaurantsScreen extends StatefulWidget {
  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  RestaurantsBloc bloc;
  Future<List<Restaurant>> restaurantsListFuture;
  int _current;

  @override
  void initState() {
    APIService api = Provider.of<APIService>(context, listen: false);
    bloc = RestaurantsBloc(apiService: api);
    restaurantsListFuture = bloc.fetchRestaurants();
    _current = 0;
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
                  child: _buildList(items),
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

  Widget _buildCarousel(List<String> urlsList) {
    return CarouselSlider(
      options: CarouselOptions(
          height: 400.0,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          // autoPlayCurve: Curves.,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          }),
      items: urlsList.map((i) {
        return CachedNetworkImage(
          imageUrl: i,
          placeholder: (context, url) => Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black, Colors.white],
              stops: [0.0, 0.4],
            )),
          ),
          errorWidget: (_, __, ___) => Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black, Colors.white],
              stops: [0.0, 0.4],
            )),
          ),
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildList(List<Restaurant> items) {
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
  }
}
