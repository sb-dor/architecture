import 'dart:developer';
import 'package:architectures/data/repositories/auth/auth_repository.dart';
import 'package:architectures/data/repositories/booking/booking_repository.dart';
import 'package:architectures/data/repositories/continent/continent_repository.dart';
import 'package:architectures/data/repositories/user_repository/user_repository.dart';
import 'package:architectures/data/services/auth/auth_local_service.dart';
import 'package:architectures/data/services/auth/auth_remote_service.dart';
import 'package:architectures/data/services/auth/auth_service.dart';
import 'package:architectures/data/services/booking/booking_local_service.dart';
import 'package:architectures/data/services/booking/booking_remote_service.dart';
import 'package:architectures/data/services/booking/booking_service.dart';
import 'package:architectures/data/services/continent/continent_local_service.dart';
import 'package:architectures/data/services/continent/continent_remote_service.dart';
import 'package:architectures/data/services/continent/continent_service.dart';
import 'package:architectures/data/services/user_services/user_local_service.dart';
import 'package:architectures/data/services/user_services/user_remote_service.dart';
import 'package:architectures/data/services/user_services/user_service.dart';
import 'package:architectures/runner/models/dependency_container.dart';
import 'package:architectures/ui/home/controller/home_controller.dart';
import 'package:architectures/ui/logout/controllers/logout_controller.dart';
import 'package:architectures/ui/search_from/controller/search_form_controller.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';

Future<DependencyContainer> composeDependencies() async {
  final dependencyContainer = DependencyContainer(
    homeController: homeControllerFactory(),
    logoutController: logoutController(),
    searchFormController: searchFormController(),
  );
  return dependencyContainer;
}

// if it's necessary somewhere else

IAuthRepository authRepository() {
  final mainUrl = const String.fromEnvironment("MAIN_URL");
  final IAuthService authRemoteService = AuthRemoteService(mainUrl: mainUrl);
  final IAuthService authLocalService = AuthLocalService();
  final internetConnectionCheckerHelper = InternetConnectionCheckerHelper();
  return AuthRepositoryImpl(
    authRemoteService: authRemoteService,
    authLocalService: authLocalService,
    internetConnectionCheckerHelper: internetConnectionCheckerHelper,
  );
}

// if it's necessary somewhere else
IBookingRepository bookingRepositoryFactory() {
  final mainUrl = const String.fromEnvironment("MAIN_URL");
  log("main url is: $mainUrl");
  final IBookingService bookingRemoteService = BookingRemoteService(mainUrl: mainUrl);
  final IBookingService bookingLocalService = BookingLocalService();
  final internetConnectionCheckerHelper = InternetConnectionCheckerHelper();

  return BookingRepositoryImpl(
    bookingRemoteService: bookingRemoteService,
    bookingLocalService: bookingLocalService,
    internetConnectionCheckerHelper: internetConnectionCheckerHelper,
  );
}

// if it's necessary somewhere else
IUserRepository userRepositoryFactory() {
  final IUserService userRemoteService = UserRemoteService();
  final IUserService userLocalService = UserLocalService();
  final internetConnectionChecker = InternetConnectionCheckerHelper();

  return UserRepositoryImpl(
    userRemoteService: userRemoteService,
    userLocalService: userLocalService,
    internetConnectionCheckerHelper: internetConnectionChecker,
  );
}

// if it's necessary somewhere else
IContinentRepository continentRepository() {
  final mainUrl = const String.fromEnvironment("MAIN_URL");
  final IContinentService continentRemoteService = ContinentRemoteService(mainUrl: mainUrl);
  final IContinentService continentLocalService = ContinentLocalService();
  final internetConnectionCheckerHelper = InternetConnectionCheckerHelper();

  return ContinentRepositoryImpl(
    continentRemoteService: continentRemoteService,
    continentLocalService: continentLocalService,
    internetConnectionCheckerHelper: internetConnectionCheckerHelper,
  );
}

LogoutController logoutController() {
  return LogoutController(authRepository: authRepository());
}

SearchFormController searchFormController() {
  return SearchFormController(continentRepository: continentRepository());
}

HomeController homeControllerFactory() {
  return HomeController(
    bookingRepository: bookingRepositoryFactory(),
    userRepository: userRepositoryFactory(),
  );
}
