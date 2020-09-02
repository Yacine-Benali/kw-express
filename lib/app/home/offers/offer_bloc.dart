import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/services/api_service.dart';

class OfferBloc {
  OfferBloc({this.apiService});
  final APIService apiService;

  Future<List<String>> fetchOffers() async {
    List<Restaurant> restaurantList = await apiService.fetchRestaurants();
    List<String> offers = List();
    for (Restaurant restaurant in restaurantList) {
      if (restaurant.offre != null) if (restaurant.offre != '')
        offers.add(restaurant.offre);
    }
    return offers;
  }

  Future<List<String>> fetchSpecialOffer() async {
    return await apiService.fetchSpecialoffer();
  }
}
