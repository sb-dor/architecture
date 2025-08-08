import 'package:architectures/data/repositories/auth/auth_repository.dart';
import 'package:flutter/foundation.dart';

class LogoutController extends ChangeNotifier {
  LogoutController({required IAuthRepository authRepository}) : _authRepository = authRepository;

  final IAuthRepository _authRepository;

  bool isLoggingOut = false;

  Future<void> logout({required VoidCallback onLogoutError}) async {
    if (isLoggingOut) return;
    isLoggingOut = true;
    notifyListeners();
    final result = await _authRepository.logout();
    isLoggingOut = false;
    notifyListeners();
  }
}
