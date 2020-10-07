enum Endpoint {
  restaurants,
  restaurantDetail,
  menu,
  updateVue,
  sendMessage,
}

class API {
  API();
  static final String host = 'fahemnydz.000webhostapp.com';

  Uri endpointUri(Endpoint endpoint) => Uri(
        scheme: 'http',
        host: host,
        path: _paths[endpoint],
      );

  static Map<Endpoint, String> _paths = {
    Endpoint.restaurants: 'test2.php',
    Endpoint.restaurantDetail: 'test3.php',
    Endpoint.menu: 'test.php',
    Endpoint.updateVue: 'updateVue.php',
    Endpoint.sendMessage: 'test4.php',
  };

  //test4
}
