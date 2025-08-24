import 'package:flutter/material.dart';
import 'package:flutter_postgres/utils/routes/routes_name.dart';
import 'package:flutter_postgres/utils/routes/screen_router.dart';
import 'package:flutter_postgres/view_model/add_item_view_model.dart';
import 'package:flutter_postgres/view_model/crud_view_model.dart';
import 'package:flutter_postgres/view_model/get_items_view_model.dart';
import 'package:flutter_postgres/view_model/update_item_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ThisApp());
}

class ThisApp extends StatelessWidget {
  const ThisApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GetItemsViewModel()),
        ChangeNotifierProvider(create: (_) => AddItemViewModel()),
        ChangeNotifierProvider(create: (_) => CrudViewModel()),
        ChangeNotifierProvider(create: (_) => UpdateItemViewModel()),
      ],
      child: MaterialApp(
        initialRoute: RoutesName.homeScreen,
        onGenerateRoute: ScreenRouter.generateRoutes,
      ),
    );
  }
}
