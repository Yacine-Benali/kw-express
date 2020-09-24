import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kwexpress/app/home/restaurant_detail/food_tile_widget.dart';
import 'package:kwexpress/app/home/restaurant_detail/order_screen.dart';
import 'package:kwexpress/app/home/restaurant_detail/restaurant_detail_bloc.dart';
import 'package:kwexpress/app/home/restaurant_detail/restaurant_header_widget.dart';
import 'package:kwexpress/app/home/restaurant_detail/restaurant_speed_dial.dart';
import 'package:kwexpress/app/models/food.dart';
import 'package:kwexpress/app/models/menu_page.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/constants/app_colors.dart';
import 'package:kwexpress/constants/size_config.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:polygon_clipper/polygon_border.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

/* TODO
  opening maps on ios 
  https://stackoverflow.com/questions/47046637/open-google-maps-app-if-available-with-flutter
*/
class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({
    Key key,
    @required this.restaurant,
    @required this.imageProfile,
    @required this.imageCover,
  }) : super(key: key);

  final Restaurant restaurant;
  final SvgPicture imageProfile;
  final SvgPicture imageCover;
  @override
  _RestaurantDetailScreenState createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with TickerProviderStateMixin {
  RestaurantDetailBloc bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<MenuPage>> menuFuture;
  List<Food> cartFoodList;
  bool showCart;
  TabController _tabController;

  @override
  void initState() {
    APIService api = Provider.of<APIService>(context, listen: false);
    bloc = RestaurantDetailBloc(apiService: api, restaurant: widget.restaurant);
    menuFuture = bloc.fetchMenu();
    cartFoodList = List();
    bloc.updateVue();
    showCart = false;

    super.initState();
  }

  void launchMaps() async {
    String googleUrl = widget.restaurant.location;
    String appleUrl = widget.restaurant.location;
    if (await canLaunch("comgooglemaps://")) {
      print('launching com googleUrl');
      await launch(googleUrl);
    } else if (await canLaunch(appleUrl)) {
      print('launching apple url');
      await launch(appleUrl);
    } else {
      throw 'Could not launch url';
    }
  }

  void addToCart(Food food) {
    if (!showCart) setState(() => showCart = !showCart);
    final snackBar = SnackBar(
      content: Text('${food.name} choisi'),
      duration: Duration(milliseconds: 500),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);

    cartFoodList.add(food);
  }

  List<Widget> getTabBar(List<MenuPage> list) {
    List<Widget> tabBarList = List(list.length);
    for (int i = 0; i < list.length; i++) {
      tabBarList[i] = Tab(
          child: Container(
        alignment: Alignment.center,
        child: Text(
          '    ' + list.elementAt(i).header.name + '    ',
        ),
      ));
    }
    return tabBarList;
  }

  List<Widget> getTabBarView(List<MenuPage> list) {
    List<Widget> tabBarViewList = List(list.length);

    for (int i = 0; i < list.length; i++) {
      tabBarViewList[i] = _buildList(list.elementAt(i).foods);
    }
    return tabBarViewList;
  }

  Widget _buildList(List<Food> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        if (index == list.length - 1) {
          return Column(
            children: [
              FoodTileWidget(
                food: list[index],
                onSelected: (t) {},
              ),
              SizedBox(
                height: 80,
              ),
            ],
          );
        }
        return FoodTileWidget(
          food: list[index],
          onSelected: (f) => addToCart(f),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Stack(
          children: [
            FutureBuilder<List<MenuPage>>(
              future: menuFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<MenuPage> menuPages = snapshot.data;
                  if (menuPages.isNotEmpty) {
                    _tabController = TabController(
                      initialIndex: 0,
                      vsync: this,
                      length: menuPages.length,
                    );
                    return WillPopScope(
                      onWillPop: () async {
                        if (cartFoodList.isNotEmpty) {
                          return showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Panier sera effacé"),
                                  content: Text(
                                      "si vous sortez de ce restaurant votre panier sera effacé"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Cancel".toUpperCase()),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("OK".toUpperCase()),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(true);
                                      },
                                    ),
                                  ],
                                );
                              });
                        } else
                          return Future.value(true);
                      },
                      child: Scaffold(
                        key: _scaffoldKey,
                        backgroundColor: Colors.white,
                        floatingActionButton: Row(
                          mainAxisAlignment: showCart
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (showCart) ...[
                              SizedBox(
                                width: 130,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: FloatingActionButton.extended(
                                    onPressed: () async {
                                      cartFoodList = await Navigator.of(context,
                                              rootNavigator: false)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (context) => OrderScreen(
                                            cartFoodList: cartFoodList,
                                            bloc: bloc,
                                          ),
                                          fullscreenDialog: true,
                                        ),
                                      );
                                    },
                                    label: Text(
                                      'VOIR PANIER',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    backgroundColor: AppColors.colorPrimary,
                                  ),
                                ),
                              ),
                            ],
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: RestaurantSpeedDial(
                                restaurant: widget.restaurant,
                              ),
                            ),
                          ],
                        ),
                        body: Column(
                          children: <Widget>[
                            RestaurantHeaderWidget(
                              restaurant: widget.restaurant,
                              imageCover: widget.imageCover,
                              imageProfile: widget.imageProfile,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Card(
                                margin: EdgeInsets.all(0),
                                semanticContainer: false,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Center(
                                      child: TabBar(
                                        labelPadding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                        ),
                                        isScrollable: true,
                                        controller: _tabController,
                                        unselectedLabelColor: Colors.black,
                                        labelColor: AppColors.colorPrimary,
                                        labelStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        tabs: getTabBar(menuPages),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TabBarView(
                                controller: _tabController,
                                children: getTabBarView(menuPages),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
                double width = SizeConfig.screenWidth / 3 - 8;
                _tabController = TabController(
                  initialIndex: 0,
                  vsync: this,
                  length: 4,
                );
                List<String> emptyUrls = [''];
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: IgnorePointer(
                    child: Column(
                      children: <Widget>[
                        RestaurantHeaderWidget(
                          restaurant: widget.restaurant,
                          imageCover: widget.imageCover,
                          imageProfile: widget.imageProfile,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Shimmer.fromColors(
                            period: Duration(milliseconds: 500),
                            baseColor: Colors.grey[200],
                            highlightColor: Colors.red[100],
                            child: TabBar(
                              labelPadding: EdgeInsets.only(left: 4, right: 4),
                              isScrollable: true,
                              controller: _tabController,
                              unselectedLabelColor: Colors.black,
                              labelColor: AppColors.colorPrimary,
                              labelStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              tabs: [
                                Tab(
                                  child: Container(
                                    width: width,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: Colors.blue, width: 1)),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    width: width,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: Colors.blue, width: 1)),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    width: width,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: Colors.blue, width: 1)),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    width: width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: Colors.blue, width: 1)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              Tab(child: Text('')),
                              Tab(child: Text('')),
                              Tab(child: Text('')),
                              Tab(child: Text('')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                heroTag: null,
                shape: PolygonBorder(
                  sides: 8,
                  borderRadius: 5.0, // Default 0.0 degrees
                  rotate: 22.0, // Default 0.0 degrees
                  border: BorderSide.none, // Default BorderSide.none
                ),
                child: Icon(Icons.chevron_left),
                onPressed: () async {
                  if (cartFoodList.isNotEmpty) {
                    return showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Panier sera effacé"),
                            content: Text(
                                "si vous sortez de ce restaurant votre panier sera effacé"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Cancel".toUpperCase()),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text("OK".toUpperCase()),
                                onPressed: () {
                                  print('pop');
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                              ),
                            ],
                          );
                        });
                  } else
                    Navigator.of(context, rootNavigator: true).pop();
                },
                backgroundColor: Colors.white.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
