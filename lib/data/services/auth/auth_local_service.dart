import 'package:architectures/data/services/auth/auth_service.dart';
import 'package:architectures/models/user.dart';

final class AuthLocalService implements AuthService {


  @override
  // TODO: implement isAuthenticated
  Future<bool> get isAuthenticated => throw UnimplementedError();

  @override
  Future<User?> login({required String email, required String password}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
