import 'package:flutter/cupertino.dart';
import 'package:flutter_postgres/repository/auth_repo/logout_repo.dart';
import 'package:flutter_postgres/utils/routes/routes_name.dart';
import 'package:flutter_postgres/view_model/token_storage_service/token_storage_service.dart';

class LogoutViewModel with ChangeNotifier {
  final LogoutRepo _logoutRepo = LogoutRepo();
  final TokenStorageService _tokenStorage = TokenStorageService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> logoutUser(context) async {
    _isLoading = true;
    notifyListeners();
    try {
      final isUserLoggedOut = await _logoutRepo.logoutUser(
        await _tokenStorage.getRefreshToken(),
      );

      _isLoading = false;
      notifyListeners();
      if (isUserLoggedOut) {
        Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
      } else {
        Navigator.pushReplacementNamed(context, RoutesName.homeScreen);
      }
    } catch (e) {
      debugPrint("Error in the LogoutViewModel: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
