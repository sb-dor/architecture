import 'package:architectures/data/services/user_services/user_service.dart';
import 'package:architectures/models/user.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';

abstract interface class IUserRepository {
  Future<User?> user();
}

final class UserRepositoryImpl implements IUserRepository {
  UserRepositoryImpl({
    required IUserService userRemoteService,
    required IUserService userLocalService,
    required InternetConnectionCheckerHelper internetConnectionCheckerHelper,
  }) : _userRemoteService = userRemoteService,
       _userLocalService = userLocalService,
       _internetConnectionCheckerHelper = internetConnectionCheckerHelper;

  final IUserService _userRemoteService;
  final IUserService _userLocalService;
  final InternetConnectionCheckerHelper _internetConnectionCheckerHelper;

  @override
  Future<User?> user() async {
    if (await _internetConnectionCheckerHelper.hasAccessToInternet()) {
      return _userRemoteService.user();
    } else {
      return _userLocalService.user();
    }
  }
}
