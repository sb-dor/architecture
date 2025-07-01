import 'package:architectures/data/services/user_services/user_service.dart';
import 'package:architectures/models/user.dart';

final class UserRemoteService implements UserService {
  @override
  Future<User?> user() async {
    return User(name: 'User remote service', picture: 'assets/user.jpg');
  }
}
