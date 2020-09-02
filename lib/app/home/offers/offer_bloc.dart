import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/services/api_service.dart';

class OfferBloc {
  OfferBloc({this.apiService});
  final APIService apiService;

  List<String> fetchOffers(List<Restaurant> restaurantList) {
    List<String> offers = List();
    for (Restaurant restaurant in restaurantList) {
      if (restaurant.offre != null) if (restaurant.offre != '')
        offers.add(restaurant.offre);
    }
    if (offers.isEmpty) {
      offers.addAll(['', '', '']);
    }
    return offers;
  }
}
