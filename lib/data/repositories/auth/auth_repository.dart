import 'package:architectures/data/services/auth/auth_service.dart';
import 'package:architectures/models/user.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';

abstract interface class IAuthRepository {
  Future<bool> get isAuthenticated;

  Future<void> login({required String email, required String password});

  Future<bool> logout();
}

final class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl({
    required this.authRemoteService,
    required this.authLocalService,
    required this.internetConnectionCheckerHelper,
  });

  final IAuthService authRemoteService;
  final IAuthService authLocalService;
  final InternetConnectionCheckerHelper internetConnectionCheckerHelper;

  @override
  // TODO: implement isAuthenticated
  Future<bool> get isAuthenticated => throw UnimplementedError();

  @override
  Future<User?> login({required String email, required String password}) async {
    final hasInternetAccess = await internetConnectionCheckerHelper.hasAccessToInternet();
    if (hasInternetAccess) {
      return authRemoteService.login(email: email, password: password);
    } else {
      return authLocalService.login(email: email, password: password);
    }
  }

  @override
  Future<bool> logout() async {
    final hasInternetAccess = await internetConnectionCheckerHelper.hasAccessToInternet();
    if (hasInternetAccess) {
      return authRemoteService.logout();
    } else {
      return authLocalService.logout();
    }
  }
}
