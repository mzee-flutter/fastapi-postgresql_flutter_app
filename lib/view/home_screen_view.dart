import 'package:flutter/material.dart';
import 'package:flutter_postgres/view/update_item_view.dart';
import 'package:flutter_postgres/view_model/get_items_view_model.dart';
import 'package:provider/provider.dart';
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
      // Future.microtask(
      //   () => Provider.of<GetItemsViewModel>(
      //     context,
      //     listen: false,
      //   ).fetchAllItems(),
      // );
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
      ),
      body: SafeArea(
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
                              titleTextStyle: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              ),
                              subtitle: Text(singleItem.description),
                              subtitleTextStyle: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            updateItemView(context, singleItem),
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
                                              return AlertDialog(
                                                title: Text('Delete Item'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Are you sure you want to delete this item',
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ElevatedButton(
                                                          style:
                                                              ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    Colors.blue,
                                                              ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        ElevatedButton(
                                                          style:
                                                              ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    Colors.red,
                                                              ),
                                                          onPressed: () async {
                                                            await crudVM
                                                                .deleteItem(
                                                                  context,
                                                                  singleItem.id,
                                                                );
                                                            if (!mounted) {
                                                              return;
                                                            }
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child: Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
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
