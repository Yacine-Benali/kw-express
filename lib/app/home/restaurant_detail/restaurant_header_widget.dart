import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kwexpress/app/models/restaurant.dart';

class RestaurantHeaderWidget extends StatefulWidget {
  const RestaurantHeaderWidget({
    Key key,
    @required this.restaurant,
    @required this.imageProfile,
    @required this.imageCover,
  }) : super(key: key);

  final Restaurant restaurant;
  final SvgPicture imageProfile;
  final SvgPicture imageCover;

  @override
  _RestaurantHeaderWidgetState createState() => _RestaurantHeaderWidgetState();
}

class _RestaurantHeaderWidgetState extends State<RestaurantHeaderWidget> {
  Restaurant get restaurant => widget.restaurant;

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
      child: Container(
        padding: EdgeInsets.all(0),
        color: Colors.white,
        child: Center(
          child: Text(
            widget.restaurant.service,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              // Align(
              //   alignment: Alignment.bottomLeft,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 8),
              //     child: _buildProfileImage(),
              //   ),
              // ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              //     color: Colors.pink,
              //     child: Wrap(
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.only(left: 40),
              //           child: Align(
              //             alignment: Alignment.bottomCenter,
              //             child: Text(
              //               'widget.restaurant.servicewidget.restaurant.servicewidget.restaurant.servicewidget.restaurant.servicewidget.restaurant.servicewidget.restaurant.servicewidget.restaurant.servicewidget.restaurant.servicewidget.restaurant.servicewidget.restaurant.service',
              //               style: TextStyle(
              //                   fontSize: 12, fontWeight: FontWeight.w400),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _buildProfileImage(),
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: AutoSizeText(
                              widget.restaurant.service,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
