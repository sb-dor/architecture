import 'package:architectures/models/user.dart';

abstract interface class AuthService {
  Future<bool> get isAuthenticated;

  Future<User?> login({required String email, required String password});

  Future<void> logout();
}
