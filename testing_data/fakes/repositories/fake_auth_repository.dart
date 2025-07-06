import 'package:architectures/data/repositories/auth/auth_repository.dart';

class FakeAuthRepository implements IAuthRepository {
  String? token;

  // TODO: implement isAuthenticated
  Future<bool> get isAuthenticated => Future.value(token != null);

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<bool> logout() {
    token = null;
    return Future.value(true);
  }
}
