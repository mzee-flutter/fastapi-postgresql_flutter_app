import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/auth_service/login_user_info_view_model.dart';
import '../view_model/auth_service/login_view_model.dart';
import '../view_model/auth_service/logout_view_model.dart';
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
              Consumer<LoginUserInfoViewModel>(
                builder: (context, loggedInUserInfoVM, child) {
                  return Material(
                    color: Colors.grey.shade300,
                    child: ListTile(
                      leading: Text(
                        registerVM.user?.id.toString() ??
                            loggedInUserInfoVM.loggedInUserInfo?.id
                                .toString() ??
                            '1',
                      ),
                      title: Text(
                        registerVM.user?.name ??
                            loggedInUserInfoVM.loggedInUserInfo?.name ??
                            'Get when login',
                      ),
                      subtitle: Text(
                        registerVM.user?.email ??
                            loggedInUserInfoVM.loggedInUserInfo?.email ??
                            'example@gmail.com',
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 40),
              Material(
                elevation: 3,
                color: Colors.grey.shade300,
                child: Consumer<LogoutViewModel>(
                  builder: (context, logoutVM, child) {
                    if (logoutVM.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      );
                    }
                    return ListTile(
                      leading: Icon(Icons.logout_rounded),
                      trailing: Text('Log out'),
                      onTap: () async {
                        await logoutVM.logoutUser(context);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
