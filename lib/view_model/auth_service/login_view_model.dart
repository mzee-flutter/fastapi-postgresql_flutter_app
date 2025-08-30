import 'package:flutter/material.dart';
import 'package:flutter_postgres/models/login_request_model.dart';
import 'package:flutter_postgres/repository/auth_repo/login_repo.dart';

import '../../models/token_model.dart';

class LoginViewModel with ChangeNotifier {
  final _loginRepo = LoginRepository();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<TokenModel?> loginUser(context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('All fields are required ')));
    }

    final existingUser = LoginRequestModel(email: email, password: password);
    _isLoading = true;
    notifyListeners();
    try {
      final user = await _loginRepo.loginUser(existingUser);

      _isLoading = false;
      notifyListeners();
      return user;
    } catch (e) {
      debugPrint('Error in LoginViewModel: ${e.toString()}');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login Failed. Try Again!')));
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
