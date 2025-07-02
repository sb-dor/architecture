import 'package:architectures/models/user.dart';

abstract interface class IAuthService {
  Future<bool> get isAuthenticated;

  Future<User?> login({required String email, required String password});

  Future<bool> logout();
}
