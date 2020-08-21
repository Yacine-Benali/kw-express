import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:kwexpress/app/home/restaurant_detail/restaurant_detail_bloc.dart';
import 'package:kwexpress/app/home/restaurant_detail/restaurant_dialog.dart';
import 'package:kwexpress/app/home/restaurants/swiper_widget.dart';
import 'package:kwexpress/app/models/food.dart';
import 'package:kwexpress/app/models/menu_page.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/common_widgets/custom_icons_icons.dart';
import 'package:kwexpress/common_widgets/empty_content.dart';
import 'package:kwexpress/common_widgets/platform_alert_dialog.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/* TODO
  opening maps on ios 
  https://stackoverflow.com/questions/47046637/open-google-maps-app-if-available-with-flutter
*/
class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({
    Key key,
    @required this.restaurant,
  }) : super(key: key);

  final Restaurant restaurant;

  @override
  _RestaurantDetailScreenState createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with TickerProviderStateMixin {
  RestaurantDetailBloc bloc;
  Future<List<MenuPage>> menuFuture;
  int _current;
  TabController _tabController;

  @override
  void initState() {
    APIService api = Provider.of<APIService>(context, listen: false);
    bloc = RestaurantDetailBloc(apiService: api, restaurant: widget.restaurant);
    menuFuture = bloc.fetchMenu();
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

  List<Widget> getTabBar(List<MenuPage> list) {
    List<Widget> tabBarList = List(list.length);
    for (int i = 0; i < list.length; i++) {
      tabBarList[i] = Tab(
          child: Text(
        list.elementAt(i).header.name,
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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 3,
            child: ListTile(
              title: Text(
                list.elementAt(index).name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(list.elementAt(index).info),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      list.elementAt(index).price + ' DA',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MenuPage>>(
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
            return Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: SpeedDial(
                // both default to 16
                animationSpeed: 50,
                marginRight: 18,
                marginBottom: 20,
                animatedIconTheme: IconThemeData(size: 22.0),
                // this is ignored if animatedIcon is non null
                child: Icon(
                  CustomIcons.order,
                  color: Colors.white,
                ),
                visible: true,
                closeManually: true,
                curve: Curves.easeIn,
                overlayColor: Colors.black,
                overlayOpacity: 0.5,
                onOpen: () => print('OPENING DIAL'),
                onClose: () => print('DIAL CLOSED'),
                tooltip: 'Speed Dial',
                heroTag: 'speed-dial-hero-tag',
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 8.0,
                shape: CircleBorder(),
                children: [
                  SpeedDialChild(
                    child: Icon(CustomIcons.commande),
                    backgroundColor: Colors.red,
                    label: 'Commander',
                    labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () => RestaurantDialog(
                      dialogType: DialogType.commander,
                    ).show(context),
                  ),
                  SpeedDialChild(
                    child: Icon(CustomIcons.reservation),
                    backgroundColor: Colors.red,
                    label: 'Reserver',
                    labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () => RestaurantDialog(
                      dialogType: DialogType.reserver,
                    ).show(context),
                  ),
                  SpeedDialChild(
                    child: Icon(CustomIcons.map),
                    backgroundColor: Colors.red,
                    label: 'Trouver',
                    labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () => launchMaps(),
                  ),
                ],
              ),
              body: Column(
                children: <Widget>[
                  SwiperWidget(urls: bloc.getUrls()),
                  Center(
                    child: Text(
                      widget.restaurant.service,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      unselectedLabelColor: Colors.black,
                      labelColor: Colors.red,
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: getTabBar(menuPages),
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
        return Material(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
