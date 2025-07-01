import 'package:architectures/data/repositories/auth/auth_repository.dart';
import 'package:flutter/foundation.dart';

class LogoutController extends ChangeNotifier {
  LogoutController({required this.authRepository});

  final AuthRepository authRepository;
}
