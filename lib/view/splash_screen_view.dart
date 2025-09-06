import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/splash_view_model.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  SplashScreenViewState createState() => SplashScreenViewState();
}

class SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    final splashVM = Provider.of<SplashViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      splashVM.getInitialRoute(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
          child: Text('Here is the app logo'),
        ),
      ),
    );
  }
}
