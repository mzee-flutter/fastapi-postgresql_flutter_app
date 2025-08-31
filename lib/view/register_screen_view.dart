import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/routes/routes_name.dart';
import '../view_model/auth_service/register_view_model.dart';

class RegisterScreenView extends StatelessWidget {
  const RegisterScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Consumer<RegisterViewModel>(
          builder: (context, registerVM, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Register User', style: TextStyle(fontSize: 30)),
                SizedBox(height: 15),
                TextFormField(
                  controller: registerVM.nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: registerVM.emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: registerVM.passwordController,
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
                    final user = await registerVM.registerUser(context);
                    if (user != null) {
                      Navigator.pushNamed(context, RoutesName.homeScreen);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: registerVM.isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : Text('Register', style: TextStyle(color: Colors.white)),
                ),

                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.loginScreen);
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: ' Sign In',
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
