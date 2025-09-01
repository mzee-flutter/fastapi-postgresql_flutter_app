import 'package:flutter/material.dart';
import 'package:flutter_postgres/models/login_request_model.dart';
import 'package:flutter_postgres/repository/auth_repo/login_repo.dart';
import 'package:flutter_postgres/repository/auth_repo/login_user_info_repo.dart';
import '../../models/auth_model.dart';
import '../../models/token_model.dart';

class LoginViewModel with ChangeNotifier {
  final _loginRepo = LoginRepository();
  final _loggedInUserRepo = LoginUserInfoRepository();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  TokenModel? _token;
  TokenModel? get token => _token;

  AuthModel? _loggedInUserInfo;
  AuthModel? get loggedInUserInfo => _loggedInUserInfo;

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
      final token = await _loginRepo.loginUser(existingUser);
      print('this is the token: ${token.accessToken}');
      final userInfo = await _loggedInUserRepo.fetchLoginUserInfo(
        token.accessToken,
      );
      _loggedInUserInfo = userInfo;
      _token = token;
      _isLoading = false;
      notifyListeners();
      return token;
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
