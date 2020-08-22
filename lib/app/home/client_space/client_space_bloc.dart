import 'package:flutter/foundation.dart';
import 'package:kwexpress/services/api_service.dart';
import 'package:kwexpress/services/auth.dart';

class ClientSpaceBloc {
  ClientSpaceBloc({
    @required this.apiService,
    @required this.auth,
  });
  final APIService apiService;
  final Auth auth;

  Future<void> sendNewRestaurant(
    String restaurantName,
    String restaurantPhoneNumber,
    String restaurantAddress,
  ) async {
    AuthUser user = await auth.currentUser();
    restaurantPhoneNumber += ' - ' + user.phoneNumber;

    try {
      await apiService.sendMessage(
          restaurantName, restaurantPhoneNumber, restaurantAddress);
    } catch (e) {}
  }

  Future<void> sendNewBug(
    String bugDescription,
  ) async {
    AuthUser user = await auth.currentUser();
    String userPhoneNumber = user.phoneNumber;
    try {
      await apiService.sendMessage(
        'BUG',
        userPhoneNumber,
        bugDescription,
      );
    } catch (e) {}
  }

  Future<void> sendNewRecelamation(
    String type,
    String description,
  ) async {
    AuthUser user = await auth.currentUser();
    String userPhoneNumber = user.phoneNumber;
    String first = "RECLAMATION " + type;

    try {
      await apiService.sendMessage(
        first,
        userPhoneNumber,
        description,
      );
    } catch (e) {}
  }

  Future<void> sendNewSuggestion(
    String description,
  ) async {
    AuthUser user = await auth.currentUser();
    String userPhoneNumber = user.phoneNumber;
    try {
      await apiService.sendMessage(
        'SUGGESTION',
        userPhoneNumber,
        description,
      );
    } catch (e) {}
  }
}
