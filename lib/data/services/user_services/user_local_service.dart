import 'package:architectures/data/services/user_services/user_service.dart';
import 'package:architectures/models/user.dart';
import 'package:architectures/utils/shared_preferences_helper.dart';

final class UserLocalService implements IUserService {
  UserLocalService({required SharedPreferencesHelper sharedPreferencesHelper})
    : _sharedPreferencesHelper = sharedPreferencesHelper;

  final SharedPreferencesHelper _sharedPreferencesHelper;

  @override
  Future<User?> user() async {
    return null;
  }
}
