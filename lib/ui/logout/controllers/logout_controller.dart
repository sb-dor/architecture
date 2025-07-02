import 'package:architectures/data/repositories/auth/auth_repository.dart';
import 'package:flutter/foundation.dart';

class LogoutController extends ChangeNotifier {
  LogoutController({required IAuthRepository authRepository}) : _authRepository = authRepository;

  final IAuthRepository _authRepository;

  Future<void> logout({required VoidCallback onLogoutError}) async {
    final result = await _authRepository.logout();
  }
}
