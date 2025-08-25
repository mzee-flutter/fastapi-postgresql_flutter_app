import 'package:flutter/material.dart';
import 'package:flutter_postgres/models/item_model.dart';
import 'package:flutter_postgres/view_model/get_items_view_model.dart';
import 'package:provider/provider.dart';

import 'crud_view_model.dart';

class AddItemViewModel with ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void addItemToDatabase(BuildContext context) {
    nameController.text.trim();
    descriptionController.text.trim();

    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Both fields are required')));
      return;
    }
    final newItem = ItemModel(
      name: nameController.text,
      description: descriptionController.text,
    );
    final getItemVM = Provider.of<GetItemsViewModel>(context, listen: false);
    Provider.of<CrudViewModel>(
      context,
      listen: false,
    ).createItem(newItem, getItemVM);
  }

  void clearFields() {
    nameController.clear();
    descriptionController.clear();
  }

  void disposeFields() {
    nameController.dispose();
    descriptionController.dispose();
  }
}
