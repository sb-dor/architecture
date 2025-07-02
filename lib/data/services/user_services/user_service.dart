import 'package:architectures/models/user.dart';

abstract interface class IUserService {
  Future<User?> user();
}
