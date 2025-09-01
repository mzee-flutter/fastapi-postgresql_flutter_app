import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/auth_service/login_view_model.dart';
import '../view_model/auth_service/register_view_model.dart';

class ProfileScreenView extends StatelessWidget {
  const ProfileScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<RegisterViewModel, LoginViewModel>(
        builder: (context, registerVM, loginVM, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Material(
                color: Colors.grey.shade300,
                child: ListTile(
                  title: Text(
                    'ACCESS-TOKEN: ${loginVM.token?.accessToken.toString() ?? 'Error'}',
                  ),
                  subtitle: Text(
                    'TOKEN-TYPE: ${loginVM.token?.tokenType.toString() ?? 'Unknown'}',
                  ),
                ),
              ),

              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Icon(Icons.person_rounded, size: 50),
                ),
              ),
              Material(
                color: Colors.grey.shade300,
                child: ListTile(
                  leading: Text(
                    registerVM.user?.id.toString() ??
                        loginVM.loggedInUserInfo?.id.toString() ??
                        '1',
                  ),
                  title: Text(
                    registerVM.user?.name ??
                        loginVM.loggedInUserInfo?.name ??
                        'Unknown',
                  ),
                  subtitle: Text(
                    registerVM.user?.email ??
                        loginVM.loggedInUserInfo?.email ??
                        'example@gmail.com',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
