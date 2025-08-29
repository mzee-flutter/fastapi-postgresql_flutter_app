import 'package:flutter/foundation.dart';
import 'package:flutter_postgres/data/base_api_services.dart';
import 'package:flutter_postgres/data/network_api_services.dart';

import '../resources/api_urls.dart';

class DeleteItemRepo {
  final BaseApiServices _services = NetworkApiServices();

  Future<void> deleteItemFromDB(int? itemID) async {
    try {
      await _services.getDeleteApiRequest(ApiURls.baseUrl + itemID.toString());
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      rethrow;
    }
  }
}
