import 'package:flutter/material.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});
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
