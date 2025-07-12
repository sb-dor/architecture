import 'package:architectures/data/repositories/auth/auth_repository.dart';
import 'package:architectures/models/user.dart';

import '../../temp_data/fake_user.dart';

class FakeAuthRepository implements IAuthRepository {
  String? token;

  @override
  Future<bool> get isAuthenticated => Future.value(token != null);

  @override
  Future<User?> login({required String email, required String password}) async {
    return kUser;
  }

  @override
  Future<bool> logout() {
    token = null;
    return Future.value(true);
  }
}
