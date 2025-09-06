import 'package:flutter/cupertino.dart';
import 'package:flutter_postgres/repository/auth_repo/login_user_info_repo.dart';

import '../../models/auth_model.dart';

class LoginUserInfoViewModel with ChangeNotifier {
  final _loggedInUserRepo = LoginUserInfoRepository();

  AuthModel? _loggedInUserInfo;
  AuthModel? get loggedInUserInfo => _loggedInUserInfo;

  Future<void> fetchLoggedInUserInfo(String? token) async {
    try {
      final user = await _loggedInUserRepo.fetchLoginUserInfo(token!);
      _loggedInUserInfo = user;
      notifyListeners();
    } catch (e) {
      debugPrint('Error in LoginUserInfoViewModel: ${e.toString()}');
    }
  }
}
