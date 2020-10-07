import 'package:flutter/material.dart';
import 'package:kwexpress/app/home/restaurant_detail/food_tile_widget.dart';
import 'package:kwexpress/app/home/restaurant_detail/restaurant_detail_bloc.dart';
import 'package:kwexpress/app/models/food.dart';
import 'package:kwexpress/app/models/restaurant_menu_header.dart';
import 'package:kwexpress/constants/size_config.dart';
import 'package:shimmer/shimmer.dart';

typedef VoidCallback = void Function();

class RestaurantMenuPageWidget extends StatefulWidget {
  const RestaurantMenuPageWidget({
    Key key,
    @required this.bloc,
    @required this.menuHeader,
    @required this.addToCart,
    @required this.foodsListFuture,
  }) : super(key: key);

  final RestaurantDetailBloc bloc;
  final RestaurantMenuHeader menuHeader;
  final Future<List<Food>> foodsListFuture;
  final void Function(Food food) addToCart;

  @override
  _RestaurantMenuPageWidgetState createState() =>
      _RestaurantMenuPageWidgetState();
}

class _RestaurantMenuPageWidgetState extends State<RestaurantMenuPageWidget>
    with AutomaticKeepAliveClientMixin {
  Future<List<Food>> foodsListFuture;

  @override
  void initState() {
    foodsListFuture = widget.foodsListFuture;
    super.initState();
  }

  void newFuture() async {
    print('${widget.menuHeader.name} failed to load');
    await Future.delayed(Duration(seconds: 1));
    foodsListFuture = widget.bloc.fetchFoods(widget.menuHeader);
    setState(() {});
  }

  @override
  bool wantKeepAlive = true;

  Widget _buildList(List<Food> list) {
    List<Widget> fuckYou = List();

    for (int index = 0; index < list.length; index++) {
      if (index == list.length - 1) {
        fuckYou.add(
          Column(
            children: [
              FoodTileWidget(
                food: list[index],
                onSelected: (f) => widget.addToCart(f),
              ),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        );
      } else {
        fuckYou.add(FoodTileWidget(
          food: list[index],
          onSelected: (f) => widget.addToCart(f),
        ));
      }
    }
    return ListView(children: fuckYou);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Food>>(
      future: foodsListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Food> foods = snapshot.data;
          if (foods.isNotEmpty) {
            return _buildList(foods);
          } else
            return Container();
        }
        if (snapshot.hasError) newFuture();

        return ListView.builder(
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Shimmer.fromColors(
                period: Duration(milliseconds: 500),
                baseColor: Colors.grey[200],
                highlightColor: Colors.red[100],
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: SizeConfig.safeBlockHorizontal * 50,
                        height: 10.0,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Container(
                          width: SizeConfig.safeBlockHorizontal * 40,
                          height: 10.0,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Container(
                          width: SizeConfig.safeBlockHorizontal * 20,
                          height: 10.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          itemCount: 6,
        );
      },
    );
  }
}
