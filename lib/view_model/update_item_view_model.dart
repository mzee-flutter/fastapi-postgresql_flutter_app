import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/item_model.dart';
import 'crud_view_model.dart';
import 'get_items_view_model.dart';

class UpdateItemViewModel with ChangeNotifier {
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  void initializeFields(ItemModel item) {
    nameController = TextEditingController(text: item.name);
    descriptionController = TextEditingController(text: item.description);
  }

  void saveChanges(context, int itemID) {
    final updatedItem = ItemModel(
      id: itemID,
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
    );
    final crudVM = Provider.of<CrudViewModel>(context, listen: false);
    final getItemVM = Provider.of<GetItemsViewModel>(context, listen: false);

    crudVM.updateItem(context, itemID, updatedItem, getItemVM);

    Navigator.pop(context);
  }

  void disposeController() {
    nameController.dispose();
    descriptionController.dispose();
  }
}
