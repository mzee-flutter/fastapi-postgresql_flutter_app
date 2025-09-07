import 'package:flutter/cupertino.dart';
import 'package:flutter_postgres/data/base_api_services.dart';
import 'package:flutter_postgres/data/network_api_services.dart';
import 'package:flutter_postgres/resources/api_urls.dart';
import 'package:flutter_postgres/view_model/token_storage_service/token_storage_service.dart';

class LogoutRepo {
  final BaseApiServices _services = NetworkApiServices();
  final TokenStorageService _tokenStorage = TokenStorageService();

  Future<bool> logoutUser(String? refreshToken) async {
    final header = {"Content-Type": "application/json"};
    final requestBody = {"refresh_token": refreshToken};

    try {
      final response = await _services.getPostApiRequest(
        ApiURls.logoutUrl,
        header,
        requestBody,
      );

      await _tokenStorage.clearTokens();
      debugPrint(response.toString());

      return true;
    } catch (e) {
      debugPrint("Error in LogoutRepo: $e");
      rethrow;
    }
  }
}
