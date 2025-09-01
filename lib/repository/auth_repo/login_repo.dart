import 'package:flutter/cupertino.dart';
import 'package:flutter_postgres/data/base_api_services.dart';
import 'package:flutter_postgres/data/network_api_services.dart';
import 'package:flutter_postgres/models/login_request_model.dart';
import 'package:flutter_postgres/resources/api_urls.dart';

import '../../models/token_model.dart';

class LoginRepository {
  final BaseApiServices _services = NetworkApiServices();

  Future<TokenModel> loginUser(LoginRequestModel user) async {
    final header = {'Content-Type': 'Application/json'};
    final requestBody = {'username': user.email, 'password': user.password};
    try {
      final response = await _services.getPostApiRequest(
        ApiURls.loginUrl,
        header,
        requestBody,
      );
      final user = TokenModel.fromJson(response);
      return user;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
