import 'package:flutter/cupertino.dart';
import 'package:flutter_postgres/view_model/auth_service/login_user_info_view_model.dart';
import 'package:flutter_postgres/view_model/token_storage_service/token_storage_service.dart';
import 'package:provider/provider.dart';

import '../utils/routes/routes_name.dart';

class SplashViewModel with ChangeNotifier {
  final TokenStorageService _tokenStorage = TokenStorageService();

  Future<void> getInitialRoute(context) async {
    final hasSession = await _tokenStorage.hasValidSession();
    // final accessToken = await _tokenStorage.getAccessToken();
    // final expiry = await _tokenStorage.getAccessTokenExpiry();
    // print("accessToken: $accessToken");
    // print("expiry: $expiry");
    // print("now: ${DateTime.now().millisecondsSinceEpoch}");
    // print("valid Session: $hasSession");

    await Future.delayed(Duration(seconds: 3));
    if (hasSession) {
      Provider.of<LoginUserInfoViewModel>(
        context,
        listen: false,
      ).fetchLoggedInUserInfo();

      Navigator.pushReplacementNamed(context, RoutesName.homeScreen);
    } else {
      Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
    }
  }
}
