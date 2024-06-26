import 'package:kwexpress/app/models/restaurant.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:retry/retry.dart';
import 'package:tuple/tuple.dart';

class HomeScreenBloc {
  HomeScreenBloc({this.apiService});
  final APIService apiService;

  Future<Tuple2<List<Restaurant>, List<String>>> fetchRestaurants() async {
    Tuple2<List<Restaurant>, List<String>> t = await retry(
      () => apiService.fetchRestaurants(),
      retryIf: (e) => true,
    );

    return t;
  }
}
