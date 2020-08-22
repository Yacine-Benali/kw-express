import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kwexpress/app/home/offers/offer_bloc.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/common_widgets/empty_content.dart';
import 'package:kwexpress/constants/assets_path.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:provider/provider.dart';

class OfferScreen extends StatefulWidget {
  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  OfferBloc bloc;
  Future<List<String>> restaurantsListFuture;

  @override
  void initState() {
    APIService api = Provider.of<APIService>(context, listen: false);
    bloc = OfferBloc(apiService: api);
    restaurantsListFuture = bloc.fetchOffers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Text('Offres Restaurants', style: TextStyle(color: Colors.grey)),
      ),
      body: FutureBuilder<List<String>>(
        future: restaurantsListFuture,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            final List<String> items = snapshot.data;
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
      ),
    );
  }

  Widget _buildList(List<String> items) {
    final SvgPicture restoOffre = SvgPicture.asset(AssetsPath.restoOffre);
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 400,
            width: 400,
            child: Card(
              elevation: 6,
              margin: EdgeInsets.all(0),
              child: CachedNetworkImage(
                imageUrl: items[index],
                placeholder: (context, url) => SizedBox(
                  child: restoOffre,
                ),
                errorWidget: (_, __, ___) => SizedBox(
                  child: restoOffre,
                ),
                imageBuilder: (context, imageProvider) => FittedBox(
                  child: restoOffre,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
