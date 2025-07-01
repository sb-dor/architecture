import 'dart:developer';
import 'package:architectures/data/repositories/booking/booking_repository.dart';
import 'package:architectures/data/repositories/continent/continent_repository.dart';
import 'package:architectures/data/repositories/user_repository/user_repository.dart';
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
import 'package:architectures/utils/internet_connection_checker_helper.dart';

Future<DependencyContainer> composeDependencies() async {
  final dependencyContainer = DependencyContainer(homeController: homeControllerFactory());
  return dependencyContainer;
}

// if it's necessary somewhere else
BookingRepository bookingRepositoryFactory() {
  final mainUrl = const String.fromEnvironment("MAIN_URL");
  log("main url is: $mainUrl");
  final BookingService bookingRemoteService = BookingRemoteService(mainUrl: mainUrl);
  final BookingService bookingLocalService = BookingLocalService();
  final internetConnectionCheckerHelper = InternetConnectionCheckerHelper();

  return BookingRepositoryImpl(
    bookingRemoteService: bookingRemoteService,
    bookingLocalService: bookingLocalService,
    internetConnectionCheckerHelper: internetConnectionCheckerHelper,
  );
}

// if it's necessary somewhere else
UserRepository userRepositoryFactory() {
  final UserService userRemoteService = UserRemoteService();
  final UserService userLocalService = UserLocalService();
  final internetConnectionChecker = InternetConnectionCheckerHelper();

  return UserRepositoryImpl(
    userRemoteService: userRemoteService,
    userLocalService: userLocalService,
    internetConnectionCheckerHelper: internetConnectionChecker,
  );
}

// if it's necessary somewhere else
ContinentRepository continentRepository() {
  final mainUrl = const String.fromEnvironment("MAIN_URL");
  final ContinentService continentRemoteService = ContinentRemoteService(mainUrl: mainUrl);
  final ContinentService continentLocalService = ContinentLocalService();
  final internetConnectionChecker = InternetConnectionCheckerHelper();

  return ContinentRepositoryImpl(
    continentRemoteService: continentRemoteService,
    continentLocalService: continentLocalService,
    internetConnectionCheckerHelper: internetConnectionChecker,
  );
}

HomeController homeControllerFactory() {
  return HomeController(
    bookingRepository: bookingRepositoryFactory(),
    userRepository: userRepositoryFactory(),
  );
}
