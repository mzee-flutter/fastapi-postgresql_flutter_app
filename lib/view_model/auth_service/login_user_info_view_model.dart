import 'package:flutter/cupertino.dart';
import 'package:flutter_postgres/repository/auth_repo/login_user_info_repo.dart';
import 'package:flutter_postgres/view_model/token_storage_service/token_storage_service.dart';
import '../../models/auth_model.dart';

class LoginUserInfoViewModel with ChangeNotifier {
  final _loggedInUserRepo = LoginUserInfoRepository();
  final TokenStorageService _tokenStorage = TokenStorageService();

  AuthModel? _loggedInUserInfo;
  AuthModel? get loggedInUserInfo => _loggedInUserInfo;

  Future<void> fetchLoggedInUserInfo() async {
    try {
      final user = await _loggedInUserRepo.fetchLoginUserInfo(
        await _tokenStorage.getAccessToken(),
      );
      _loggedInUserInfo = user;
      notifyListeners();
    } catch (e) {
      debugPrint('Error in LoginUserInfoViewModel: ${e.toString()}');
    }
  }
}
