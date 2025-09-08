import 'package:flutter/material.dart';
import 'package:flutter_postgres/view_model/get_items_view_model.dart';
import 'package:provider/provider.dart';
import '../resources/UI_resources/ItemListTile.dart';

import '../utils/routes/routes_name.dart';
import '../view_model/crud_view_model.dart';
import 'add_item_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final getItemVM = Provider.of<GetItemsViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getItemVM.fetchAllItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Home Screen"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutesName.profileScreen);
              },
              icon: Icon(Icons.person_2_rounded),
              style: IconButton.styleFrom(backgroundColor: Colors.white),
            ),
          ),
        ],
      ),

      ///the stack is for the watermark on the scaffold
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Container(
                alignment: Alignment.center,
                height: 200,
                width: 200,

                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  'Items',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Consumer2<GetItemsViewModel, CrudViewModel>(
              builder: (context, getItemVM, crudVM, child) {
                final itemCount =
                    getItemVM.allItemsList.length + (crudVM.isLoading ? 1 : 0);
                if (getItemVM.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (getItemVM.allItemsList.isEmpty) {
                  return Center(child: Text('Item not found'));
                }
                return Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          if (index < getItemVM.allItemsList.length) {
                            final singleItem = getItemVM.allItemsList[index];
                            return ItemListTile(singleItem: singleItem);
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => addItemView(context),
          );
        },
      ),
    );
  }
}

///The server must be run on host 0.0.0.0 port 8000 to give access from outside calls
