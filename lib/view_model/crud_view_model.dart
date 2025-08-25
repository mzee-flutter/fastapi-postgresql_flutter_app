import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_postgres/models/item_model.dart';
import 'package:flutter_postgres/repository/add_item_repo.dart';
import 'package:flutter_postgres/repository/update_item_repo.dart';
import 'package:flutter_postgres/view_model/get_items_view_model.dart';
import 'package:provider/provider.dart';
import '../repository/delete_item_repo.dart';

class CrudViewModel with ChangeNotifier {
  final AddItemRepo _addItemRepo = AddItemRepo();
  final DeleteItemRepo _deleteItemRepo = DeleteItemRepo();
  final UpdateItemRepo _updateItemRepo = UpdateItemRepo();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> createItem(ItemModel item, GetItemsViewModel getItemVM) async {
    try {
      _isLoading = true;
      notifyListeners();
      final addedItem = await _addItemRepo.addItemToDatabase(item);
      getItemVM.addNewItem(addedItem);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateItem(
    context,
    int itemID,
    ItemModel item,
    GetItemsViewModel getItemVM,
  ) async {
    try {
      final updatedItem = await _updateItemRepo.updateAndFetchItem(
        itemID,
        item,
      );
      getItemVM.updateItemInList(updatedItem);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> deleteItem(context, int? itemID) async {
    try {
      await _deleteItemRepo.deleteItemFromDB(itemID);
      Provider.of<GetItemsViewModel>(
        context,
        listen: false,
      ).removeItemFromList(itemID!);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}

/// look for the solution the last response of the chatgpt
