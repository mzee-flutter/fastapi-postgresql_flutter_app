import 'package:flutter/material.dart';
import 'package:flutter_postgres/models/auth_model.dart';
import 'package:flutter_postgres/models/register_request_model.dart';
import 'package:flutter_postgres/repository/auth_repo/register_repo.dart';

class RegisterViewModel with ChangeNotifier {
  final RegisterRepository _registerRepo = RegisterRepository();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<AuthModel?> registerUser(BuildContext context) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All fields are required')));
      return null;
    }

    final newUser = RegisterRequestModel(
      name: name,
      email: email,
      password: password,
    );

    _isLoading = true;
    notifyListeners();
    try {
      final user = await _registerRepo.registerUser(newUser);

      _isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ${user.name} registered successfully')),
      );

      return user;
    } catch (e) {
      debugPrint('Error in RegisterViewModel: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed. Try again.')),
      );
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
