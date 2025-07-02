import 'package:architectures/data/services/user_services/user_service.dart';
import 'package:architectures/models/user.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';

abstract interface class IUserRepository {
  Future<User?> user();
}

final class UserRepositoryImpl implements IUserRepository {
  UserRepositoryImpl({
    required this.userRemoteService,
    required this.userLocalService,
    required this.internetConnectionCheckerHelper,
  });

  final IUserService userRemoteService;
  final IUserService userLocalService;
  final InternetConnectionCheckerHelper internetConnectionCheckerHelper;

  @override
  Future<User?> user() async {
    if (await internetConnectionCheckerHelper.hasAccessToInternet()) {
      return userRemoteService.user();
    } else {
      return userLocalService.user();
    }
  }
}
