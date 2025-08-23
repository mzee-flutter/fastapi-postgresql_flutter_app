import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../view_model/update_item_view_model.dart';
import 'package:flutter_postgres/models/item_model.dart';

Widget updateItemView(BuildContext context, ItemModel item) {
  final updateItemVM = Provider.of<UpdateItemViewModel>(context, listen: false);
  updateItemVM.initializeFields(item);
  return Consumer<UpdateItemViewModel>(
    builder: (context, updateItemVM, child) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Update Item',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        content: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15),
              TextFormField(
                controller: updateItemVM.nameController,
                decoration: InputDecoration(hintText: 'Enter item name'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: updateItemVM.descriptionController,
                decoration: InputDecoration(hintText: 'Enter item description'),
              ),
              SizedBox(height: 15),

              ElevatedButton(
                onPressed: () {
                  updateItemVM.saveChanges(context, item.id!);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
