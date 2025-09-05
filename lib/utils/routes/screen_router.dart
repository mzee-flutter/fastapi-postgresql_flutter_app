import 'package:flutter/material.dart';
import 'package:flutter_postgres/utils/routes/routes_name.dart';
import 'package:flutter_postgres/view/home_screen_view.dart';
import 'package:flutter_postgres/view/login_screen_view.dart';
import 'package:flutter_postgres/view/profile_screen_view.dart';
import 'package:flutter_postgres/view/register_screen_view.dart';
import 'package:flutter_postgres/view/splash_screen_view.dart';

class ScreenRouter {
  static MaterialPageRoute generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.homeScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RoutesName.loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreenView());
      case RoutesName.registerScreen:
        return MaterialPageRoute(builder: (_) => RegisterScreenView());

      case RoutesName.profileScreen:
        return MaterialPageRoute(builder: (_) => ProfileScreenView());
      case RoutesName.splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreenView());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text("No routes to this page"))),
        );
    }
  }
}
