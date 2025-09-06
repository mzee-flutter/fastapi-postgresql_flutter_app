import 'package:flutter/cupertino.dart';
import 'package:flutter_postgres/data/base_api_services.dart';
import 'package:flutter_postgres/data/network_api_services.dart';
import 'package:flutter_postgres/models/login_request_model.dart';
import 'package:flutter_postgres/resources/api_urls.dart';
import 'package:flutter_postgres/view_model/token_storage_service/token_storage_service.dart';

import '../../models/token_model.dart';

class LoginRepository {
  final BaseApiServices _services = NetworkApiServices();
  final TokenStorageService _tokenStorage = TokenStorageService();

  Future<bool> loginUser(LoginRequestModel user) async {
    final header = {'Content-Type': 'application/json'};
    final requestBody = user.toJson();
    try {
      final response = await _services.getPostApiRequest(
        ApiURls.loginUrl,
        header,
        requestBody,
      );

      final accessToken = response["access_token"];
      final refreshToken = response["refresh_token"];

      await _tokenStorage.saveToken(accessToken, refreshToken);

      // final user = TokenModel.fromJson(response);

      return true;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
