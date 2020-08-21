import 'package:flutter/material.dart';
import 'package:kwexpress/app/home/restaurant_detail/restaurant_detail_bloc.dart';
import 'package:kwexpress/app/home/restaurants/swiper_widget.dart';
import 'package:kwexpress/app/models/food.dart';
import 'package:kwexpress/app/models/menu_page.dart';
import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/common_widgets/empty_content.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:provider/provider.dart';

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
            return Material(
              color: Colors.white,
              child: Column(
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
