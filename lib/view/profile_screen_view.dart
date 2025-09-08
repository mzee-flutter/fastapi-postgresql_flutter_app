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
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Spacer(),
                Container(
                  height: 200,
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade700,
                  ),
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Consumer<LoginUserInfoViewModel>(
                  builder: (context, loggedInUserInfoVM, child) {
                    return Material(
                      elevation: 3,
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5),

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
                Spacer(),
                Material(
                  elevation: 3,
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                  child: Consumer<LogoutViewModel>(
                    builder: (context, logoutVM, child) {
                      if (logoutVM.isLoading) {
                        return Center(
                          child: CircularProgressIndicator(color: Colors.blue),
                        );
                      }
                      return ListTile(
                        leading: Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                          size: 30,
                        ),

                        title: Text('Log out'),
                        titleTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),

                        onTap: () async {
                          await logoutVM.logoutUser(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
