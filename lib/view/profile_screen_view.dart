import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/auth_service/register_view_model.dart';

class ProfileScreenView extends StatelessWidget {
  const ProfileScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RegisterViewModel>(
        builder: (context, registerVM, child) {
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
              Material(
                color: Colors.grey.shade300,
                child: ListTile(
                  leading: Text(registerVM.user?.id.toString() ?? '1'),
                  title: Text(registerVM.user?.name ?? 'Unknown'),
                  subtitle: Text(registerVM.user?.email ?? 'example@gmail.com'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
