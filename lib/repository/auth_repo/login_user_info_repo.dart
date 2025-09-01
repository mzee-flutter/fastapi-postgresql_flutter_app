import 'package:flutter/cupertino.dart';
import 'package:flutter_postgres/data/base_api_services.dart';
import 'package:flutter_postgres/data/network_api_services.dart';
import 'package:flutter_postgres/resources/api_urls.dart';

import '../../models/auth_model.dart';

class LoginUserInfoRepository {
  final BaseApiServices _services = NetworkApiServices();

  Future<AuthModel> fetchLoginUserInfo(String token) async {
    final header = {'Authorization': 'Bearer $token'};
    try {
      final response = await _services.getGetApiRequest(
        ApiURls.getMeUrl,
        header,
      );

      final item = AuthModel.fromJson(response);
      return item;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
