import 'package:flutter/foundation.dart';
import 'package:flutter_postgres/models/item_model.dart';
import 'package:flutter_postgres/repository/get_items_repo.dart';

class GetItemsViewModel with ChangeNotifier {
  final getItemRepo = GetItemsRepo();
  final List<ItemModel> _allItemsList = [];

  List<ItemModel> get allItemsList => _allItemsList;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void addNewItem(ItemModel item) {
    _allItemsList.add(item);
    notifyListeners();
  }

  void removeItemFromList(int itemID) {
    _allItemsList.removeWhere((item) => item.id == itemID);
    notifyListeners();
  }

  void updateItemInList(ItemModel updatedItem) {
    final index = _allItemsList.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _allItemsList[index] = updatedItem;
      notifyListeners();
    }
  }

  Future<void> fetchAllItems() async {
    _isLoading = true;
    notifyListeners();
    try {
      final items = await getItemRepo.fetchAllItems();
      _allItemsList
        ..clear()
        ..addAll(items);
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
}
