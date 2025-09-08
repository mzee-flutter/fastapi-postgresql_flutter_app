import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/item_model.dart';
import '../../view/update_item_view.dart';
import '../../view_model/crud_view_model.dart';
import 'delete_dialog_box.dart';

class ItemListTile extends StatelessWidget {
  const ItemListTile({super.key, required this.singleItem});

  final ItemModel singleItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 2,
        child: ListTile(
          key: ValueKey(singleItem.id),
          tileColor: Colors.grey.shade300,
          shape: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          ),

          title: Text(singleItem.name),
          titleTextStyle: TextStyle(fontSize: 17, color: Colors.black),
          subtitle: Text(singleItem.description),
          subtitleTextStyle: TextStyle(color: Colors.grey.shade600),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => updateItemView(context, singleItem),
                  );
                },
                child: Icon(Icons.create_rounded),
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Consumer<CrudViewModel>(
                        builder: (context, crudVM, child) {
                          return DeleteDialogBox(
                            singleItem: singleItem,
                            crudVM: crudVM,
                          );
                        },
                      );
                    },
                  );
                },
                child: Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
