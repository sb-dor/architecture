import 'dart:convert';

import 'package:architectures/data/services/auth/auth_service.dart';
import 'package:architectures/models/user.dart';
import 'package:architectures/utils/shared_preferences_helper.dart';

class AuthLocalService implements IAuthService {
  AuthLocalService({required SharedPreferencesHelper sharedPreferencesHelper})
    : _sharedPreferencesHelper = sharedPreferencesHelper;

  final SharedPreferencesHelper _sharedPreferencesHelper;

  @override
  // TODO: implement isAuthenticated
  Future<bool> get isAuthenticated async {
    final user = _sharedPreferencesHelper.getString('user');
    return user != null;
  }

  @override
  Future<User?> login({required String email, required String password}) async {
    final checkUserLocally = _sharedPreferencesHelper.getString('user');
    if (checkUserLocally != null) {
      return User.fromJson(jsonDecode(checkUserLocally));
    }
    // just for test
    final user = User(name: email, picture: password);
    await _sharedPreferencesHelper.saveString('user', jsonEncode(user.toJson()));
    return user;
  }

  @override
  Future<bool> logout() async {
    final checkUserLocally = _sharedPreferencesHelper.getString('user');
    if (checkUserLocally == null) return true;
    await _sharedPreferencesHelper.remove('user');
    return true;
  }
}
