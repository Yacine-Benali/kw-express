import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/common_widgets/custom_icons_icons.dart';

class RestaurantTileWidget extends StatefulWidget {
  const RestaurantTileWidget({
    Key key,
    @required this.restaurant,
    @required this.imageCover,
    @required this.imageProfile,
  }) : super(key: key);

  final Restaurant restaurant;
  final SvgPicture imageProfile;
  final SvgPicture imageCover;

  @override
  _RestaurantTileWidgetState createState() => _RestaurantTileWidgetState();
}

class _RestaurantTileWidgetState extends State<RestaurantTileWidget> {
  Restaurant get restaurant => widget.restaurant;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: widget.imageProfile,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: CachedNetworkImage(
                          placeholder: (context, url) => widget.imageCover,
                          imageUrl: restaurant.imageCover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: () {},
                        color: Colors.white,
                        child: Text(
                          restaurant.time,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: Text(
                    restaurant.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(restaurant.address),
                  trailing: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {},
                    child: Icon(
                      CustomIcons.heart,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
