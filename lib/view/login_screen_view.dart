import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/routes/routes_name.dart';
import '../view_model/auth_service/login_view_model.dart';

class LoginScreenView extends StatelessWidget {
  const LoginScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Consumer<LoginViewModel>(
          builder: (context, loginVM, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Login User', style: TextStyle(fontSize: 30)),
                SizedBox(height: 25),

                TextFormField(
                  controller: loginVM.emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: loginVM.passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    final user = await loginVM.loginUser(context);
                    if (user?.accessToken != null) {
                      Navigator.pushNamed(context, RoutesName.homeScreen);
                    }

                    loginVM.clearFields();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: loginVM.isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : Text('Login', style: TextStyle(color: Colors.white)),
                ),

                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.registerScreen);
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: 'Don\'t have an account? '),
                        TextSpan(
                          text: ' Sign Up',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
