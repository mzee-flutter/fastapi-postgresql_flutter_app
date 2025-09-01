import 'package:flutter/widgets.dart';
import 'package:flutter_postgres/data/base_api_services.dart';
import 'package:flutter_postgres/data/network_api_services.dart';
import 'package:flutter_postgres/models/item_model.dart';
import 'package:flutter_postgres/resources/api_urls.dart';

class UpdateItemRepo {
  final BaseApiServices _services = NetworkApiServices();

  Future<ItemModel> updateAndFetchItem(int itemID, ItemModel item) async {
    final header = {
      'accept': 'Application/json',
      'Content-Type': 'Application/json',
    };
    final requestBody = item.toJson();

    try {
      final response = await _services.getPutApiRequest(
        ApiURls.baseUrl + itemID.toString(),
        header,
        requestBody,
      );

      return ItemModel(
        id: response['id'],
        name: response['name'],
        description: response['description'],
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
