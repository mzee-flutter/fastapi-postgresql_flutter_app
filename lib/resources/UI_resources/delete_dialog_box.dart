import 'package:flutter/material.dart';

import '../../models/item_model.dart';
import '../../view_model/crud_view_model.dart';

class DeleteDialogBox extends StatelessWidget {
  const DeleteDialogBox({
    super.key,
    required this.singleItem,
    required this.crudVM,
  });

  final ItemModel singleItem;
  final CrudViewModel crudVM;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Delete Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Are you sure you want to delete this item'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  await crudVM.deleteItem(context, singleItem.id);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: Text('Delete', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
