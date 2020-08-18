enum Endpoint {
  restaurants,
  restaurantDetail,
  menu,
  deaths,
  recovered,
}

class API {
  API();
  static final String host = 'fahemnydz.000webhostapp.com';

  Uri endpointUri(Endpoint endpoint) => Uri(
        scheme: 'https',
        host: host,
        path: _paths[endpoint],
      );

  static Map<Endpoint, String> _paths = {
    Endpoint.restaurants: 'test2.php',
    Endpoint.restaurantDetail: 'test3.php',
    Endpoint.menu: 'test.php',
    Endpoint.deaths: 'deaths',
    Endpoint.recovered: 'recovered',
  };
}
