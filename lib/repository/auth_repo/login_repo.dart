import 'package:flutter/cupertino.dart';
import 'package:flutter_postgres/data/base_api_services.dart';
import 'package:flutter_postgres/data/network_api_services.dart';
import 'package:flutter_postgres/models/login_request_model.dart';
import 'package:flutter_postgres/resources/api_urls.dart';

import '../../models/token_model.dart';

class LoginRepository {
  final BaseApiServices _services = NetworkApiServices();

  Future<TokenModel> loginUser(LoginRequestModel user) async {
    final header = {'Content-Type': 'application/json'};
    final requestBody = user.toJson();
    try {
      final response = await _services.getPostApiRequest(
        ApiURls.loginUrl,
        header,
        requestBody,
      );
      print(response);
      final user = TokenModel.fromJson(response);
      print(user);
      return user;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
