import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kwexpress/app/home/offers/offer_bloc.dart';
import 'package:kwexpress/common_widgets/empty_content.dart';
import 'package:kwexpress/common_widgets/platform_alert_dialog.dart';
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
  Future<List<String>> offerList;
  SvgPicture placeHolder;

  @override
  void initState() {
    placeHolder = SvgPicture.asset(AssetsPath.offre);
    APIService api = Provider.of<APIService>(context, listen: false);
    bloc = OfferBloc(apiService: api);
    restaurantsListFuture = bloc.fetchOffers();
    offerList = bloc.fetchSpecialOffer();

    super.initState();
  }

  showpop(context) async {
    await PlatformAlertDialog(
      defaultActionText: 'ok',
      content: 'null',
      title: 'null',
    ).show(context);
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
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([restaurantsListFuture, offerList]),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            final List<String> items = snapshot.data[0];
            final url = snapshot.data[1].elementAt(0);
            // print(url);
            Widget image = CachedNetworkImage(
              placeholder: (context, url) => placeHolder,
              errorWidget: (_, __, ___) => placeHolder,
              imageUrl: url,
            );

            if (items.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => showDialog(
                  context: context,
                  builder: (_) => ImageDialog(
                    imageProvider: image,
                  ),
                ),
              );
              return _buildList(items);
            } else {
              return EmptyContent(
                title: 'title',
                message: 'message',
              );
            }
          } else if (snapshot.hasError) {
            return EmptyContent(
              title: 'quelque chose s\'est mal passé',
              message: 'S\'il vous plait, vérifiez votre connexion internet',
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
