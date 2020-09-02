import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kwexpress/app/home/offers/offer_bloc.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/constants/assets_path.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:provider/provider.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({
    Key key,
    @required this.restaurantsList,
    @required this.specialOffersList,
  }) : super(key: key);

  final List<Restaurant> restaurantsList;
  final List<String> specialOffersList;
  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  OfferBloc bloc;
  List<String> restoOffersList;
  SvgPicture placeHolder;

  @override
  void initState() {
    placeHolder = SvgPicture.asset(AssetsPath.offre);
    APIService api = Provider.of<APIService>(context, listen: false);
    bloc = OfferBloc(apiService: api);
    restoOffersList = bloc.fetchOffers(widget.restaurantsList);
    final url = widget.specialOffersList.elementAt(0);
    Widget image = CachedNetworkImage(
      placeholder: (context, url) => placeHolder,
      errorWidget: (_, __, ___) => placeHolder,
      imageUrl: url,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      return showDialog(
        context: context,
        builder: (_) => ImageDialog(
          imageProvider: image,
        ),
      );
    });
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
      body: _buildList(restoOffersList),
    );
  }

  Widget _buildList(List<String> items) {
    final SvgPicture restoOffre = SvgPicture.asset(AssetsPath.restoOffre);
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        // print(items[index]);
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
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ImageDialog extends StatelessWidget {
  const ImageDialog({Key key, this.imageProvider}) : super(key: key);

  final Widget imageProvider;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        // height: SizeConfig.screenHeight - 200,
        // width: SizeConfig.screenWidth - 80,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: imageProvider,
        ),
      ),
    );
  }
}
