import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_postgres/data/base_api_services.dart';
import 'package:flutter_postgres/data/network_api_services.dart';

import '../models/item_model.dart';
import '../resources/api_urls.dart';

class GetItemsRepo {
  final BaseApiServices _services = NetworkApiServices();

  Future<List<ItemModel>> fetchAllItems() async {
    try {
      final response = await _services.getGetApiRequest(
        ApiURls.getItemsURl,
        null,
      );

      final items = (response as List)
          .map((json) => ItemModel.fromJson(json))
          .toList();
      return items;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      rethrow;
    }
  }
}
