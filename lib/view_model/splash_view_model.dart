import 'package:flutter/cupertino.dart';
import 'package:flutter_postgres/view_model/token_storage_service/token_storage_service.dart';

import '../utils/routes/routes_name.dart';

class SplashViewModel with ChangeNotifier {
  final TokenStorageService _tokenStorage = TokenStorageService();

  Future<void> getInitialRoute(context) async {
    final hasSession = await _tokenStorage.hasValidSession();
    // final accessToken = await _tokenStorage.getAccessToken();
    // final expiry = await _tokenStorage.getAccessTokenExpiry();
    // print("accessTOken: $accessToken");
    // print("expirey: $expiry");
    // print("now: ${DateTime.now().millisecondsSinceEpoch}");
    // print("valid Session: $hasSession");

    await Future.delayed(Duration(seconds: 3));
    if (hasSession) {
      Navigator.pushReplacementNamed(context, RoutesName.homeScreen);
    } else {
      Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
    }
  }
}
