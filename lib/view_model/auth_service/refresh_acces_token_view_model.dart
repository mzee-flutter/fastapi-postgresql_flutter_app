import 'package:flutter/cupertino.dart';
import 'package:flutter_postgres/data/network_api_services.dart';
import 'package:flutter_postgres/repository/auth_repo/refresh_access_token_repo.dart';
import 'package:flutter_postgres/view_model/token_storage_service/token_storage_service.dart';

class RefreshAccessTokenViewModel with ChangeNotifier {
  final RefreshAccessTokenRepo _accessTokenRepo = RefreshAccessTokenRepo(
    NetworkApiServices(),
  );
  final TokenStorageService _tokenStorage = TokenStorageService();

  Future<void> getFreshAccessToken() async {
    try {
      await _accessTokenRepo.getFreshAccessToken(
        await _tokenStorage.getRefreshToken(),
      );
    } catch (e) {
      debugPrint("Error from RefreshAccessTokenViewModel: $e");
    }
  }
}
