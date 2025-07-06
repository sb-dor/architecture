import 'package:architectures/data/repositories/user_repository/user_repository.dart';
import 'package:architectures/models/user.dart';

import '../../temp_data/fake_user.dart';

class FakeUserRepositoryImpl implements IUserRepository {
  @override
  Future<User?> user() => Future.value(kUser);
}
