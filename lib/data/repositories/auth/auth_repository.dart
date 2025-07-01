import 'package:architectures/data/services/auth/auth_service.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';

abstract interface class AuthRepository {
  Future<bool> get isAuthenticated;

  Future<void> login({required String email, required String password});

  Future<void> logout();
}

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.authRemoteService,
    required this.authLocalService,
    required this.internetConnectionCheckerHelper,
  });

  final AuthService authRemoteService;
  final AuthService authLocalService;
  final InternetConnectionCheckerHelper internetConnectionCheckerHelper;

  @override
  // TODO: implement isAuthenticated
  Future<bool> get isAuthenticated => throw UnimplementedError();

  @override
  Future<void> login({required String email, required String password}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
