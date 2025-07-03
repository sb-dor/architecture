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
    required IAuthService authRemoteService,
    required IAuthService authLocalService,
    required InternetConnectionCheckerHelper internetConnectionCheckerHelper,
  }) : _authRemoteService = authRemoteService,
       _authLocalService = authLocalService,
       _internetConnectionCheckerHelper = internetConnectionCheckerHelper;

  final IAuthService _authRemoteService;
  final IAuthService _authLocalService;
  final InternetConnectionCheckerHelper _internetConnectionCheckerHelper;

  @override
  // TODO: implement isAuthenticated
  Future<bool> get isAuthenticated => throw UnimplementedError();

  @override
  Future<User?> login({required String email, required String password}) async {
    final hasInternetAccess = await _internetConnectionCheckerHelper.hasAccessToInternet();
    if (hasInternetAccess) {
      return _authRemoteService.login(email: email, password: password);
    } else {
      return _authLocalService.login(email: email, password: password);
    }
  }

  @override
  Future<bool> logout() async {
    final hasInternetAccess = await _internetConnectionCheckerHelper.hasAccessToInternet();
    if (hasInternetAccess) {
      return _authRemoteService.logout();
    } else {
      return _authLocalService.logout();
    }
  }
}
