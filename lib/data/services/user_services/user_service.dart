import 'package:architectures/models/user.dart';

abstract interface class UserService {
  Future<User?> user();
}
