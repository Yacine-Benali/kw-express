import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kwexpress/app/home/restaurant_detail/restaurant_detail_screen.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/common_widgets/custom_icons_icons.dart';
import 'package:kwexpress/constants/app_colors.dart';
import 'package:kwexpress/constants/assets_path.dart';
import 'package:kwexpress/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantTileWidget extends StatefulWidget {
  const RestaurantTileWidget({
    Key key,
    @required this.restaurant,
    @required this.imageCover,
    @required this.imageProfile,
    @required this.localStorageService,
  }) : super(key: key);

  final Restaurant restaurant;
  final SvgPicture imageProfile;
  final SvgPicture imageCover;
  final LocalStorageService localStorageService;

  @override
  _RestaurantTileWidgetState createState() => _RestaurantTileWidgetState();
}

class _RestaurantTileWidgetState extends State<RestaurantTileWidget> {
  Restaurant get restaurant => widget.restaurant;
  @override
  initState() {
    super.initState();
  }

  Widget _buildProfileImage() {
    return SizedBox(
      height: 80,
      width: 80,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(),
        child: CachedNetworkImage(
          imageUrl: widget.restaurant.imageProfile,
          placeholder: (context, url) => SizedBox(
            height: 80,
            width: 80,
            child: widget.imageProfile,
          ),
          errorWidget: (_, __, ___) => SizedBox(
            height: 80,
            width: 80,
            child: widget.imageProfile,
          ),
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 5.0,
              ),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeButton() {
    return SizedBox(
      width: 90,
      child: RaisedButton(
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        onPressed: null,
        disabledColor: Colors.white,
        disabledElevation: 3,
        color: Colors.white,
        child: Text(
          restaurant.time,
          style: TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () => Navigator.of(context, rootNavigator: false).push(
            MaterialPageRoute(
              builder: (context) => RestaurantDetailScreen(
                restaurant: restaurant,
              ),
              fullscreenDialog: true,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 190,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 150,
                      child: SizedBox.expand(
                        child: CachedNetworkImage(
                          imageUrl: widget.restaurant.imageCover,
                          placeholder: (context, url) => SizedBox(
                            height: 150,
                            width: 150,
                            child: widget.imageCover,
                          ),
                          errorWidget: (_, __, ___) => SizedBox(
                            height: 150,
                            width: 150,
                            child: widget.imageCover,
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
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: _buildProfileImage(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildTimeButton(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            AutoSizeText(
                              restaurant.address,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Container(
                        child: FloatingActionButton(
                          heroTag: widget.restaurant.id,
                          backgroundColor: Colors.white,
                          onPressed: () async {
                            if (widget.restaurant.isFavorit) {
                              widget.restaurant.isFavorit = false;
                              widget.localStorageService
                                  .removeFromFavorite(widget.restaurant.id);
                            } else {
                              widget.restaurant.isFavorit = true;
                              widget.localStorageService
                                  .addToFavorite(widget.restaurant.id);
                            }

                            setState(() {});
                          },
                          child: Icon(
                            widget.restaurant.isFavorit
                                ? CustomIcons.selected_heart
                                : CustomIcons.heart,
                            color: widget.restaurant.isFavorit
                                ? AppColors.colorPrimary
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
