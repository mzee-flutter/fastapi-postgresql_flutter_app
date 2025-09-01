import 'package:flutter/foundation.dart';
import 'package:flutter_postgres/data/base_api_services.dart';
import 'package:flutter_postgres/data/network_api_services.dart';
import 'package:flutter_postgres/models/register_request_model.dart';
import 'package:flutter_postgres/resources/api_urls.dart';

import '../../models/auth_model.dart';

class RegisterRepository {
  final BaseApiServices _services = NetworkApiServices();

  Future<AuthModel> registerUser(RegisterRequestModel user) async {
    final header = {
      'accept': "Application/json",
      'Content-Type': 'Application/json',
    };

    final requestBody = user.toJson();

    try {
      final response = await _services.getPostApiRequest(
        ApiURls.registerUrl,
        header,
        requestBody,
      );

      final user = AuthModel.fromJson(response);
      return user;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
