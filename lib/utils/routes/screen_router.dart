import 'package:flutter/material.dart';
import 'package:flutter_postgres/utils/routes/routes_name.dart';
import 'package:flutter_postgres/view/home_screen_view.dart';

class ScreenRouter {
  static MaterialPageRoute generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.homeScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text("No routes to this page"))),
        );
    }
  }
}
