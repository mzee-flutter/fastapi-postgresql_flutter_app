import 'package:flutter/cupertino.dart';
import 'package:flutter_postgres/view_model/token_storage_service/token_storage_service.dart';

import '../utils/routes/routes_name.dart';

class SplashViewModel with ChangeNotifier {
  final TokenStorageService _tokenStorage = TokenStorageService();

  Future<void> getInitialRoute(context) async {
    final isExpired = await _tokenStorage.isAccessTokenExpired();

    if (!isExpired) {
      Navigator.pushNamed(context, RoutesName.splashScreen);
    } else {
      Navigator.pushNamed(context, RoutesName.loginScreen);
    }
  }
}
