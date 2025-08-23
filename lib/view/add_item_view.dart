import 'package:flutter/material.dart';
import 'package:flutter_postgres/view_model/add_item_view_model.dart';
import 'package:provider/provider.dart';

Widget addItemView(BuildContext context) {
  return Consumer<AddItemViewModel>(
    builder: (context, addItemVM, child) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Add Item',
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
                controller: addItemVM.nameController,
                decoration: InputDecoration(hintText: 'Enter item name'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: addItemVM.descriptionController,
                decoration: InputDecoration(hintText: 'Enter item description'),
              ),
              SizedBox(height: 15),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  addItemVM.addItemToDatabase(context);
                  addItemVM.clearFields();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text('Add Item', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    },
  );
}
