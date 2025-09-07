import 'package:flutter/cupertino.dart';
import 'package:flutter_postgres/data/base_api_services.dart';
import 'package:flutter_postgres/resources/api_urls.dart';
import 'package:flutter_postgres/view_model/token_storage_service/token_storage_service.dart';

class RefreshAccessTokenRepo {
  final BaseApiServices _services;

  final TokenStorageService _tokenStorage = TokenStorageService();

  RefreshAccessTokenRepo(this._services);

  Future<void> getFreshAccessToken(String? token) async {
    final headers = {"Content-Type": "application/json"};

    final requestBody = {"refresh_token": token};

    try {
      final response = await _services.getPostApiRequest(
        ApiURls.refreshAccessToken,
        headers,
        requestBody,
      );

      final accessToken = response["access_token"];
      final refreshToken = response["refresh_token"];
      final accessTokenExpiry = response["expire_at"];

      await _tokenStorage.saveToken(
        accessToken,
        refreshToken,
        accessTokenExpiry,
      );
    } catch (e) {
      debugPrint("RefreshAccessTokenRepo: $e");
      rethrow;
    }
  }
}
