import 'dart:developer';
import 'package:architectures/data/repositories/activities/activities_repository.dart';
import 'package:architectures/data/repositories/auth/auth_repository.dart';
import 'package:architectures/data/repositories/booking/booking_repository.dart';
import 'package:architectures/data/repositories/continent/continent_repository.dart';
import 'package:architectures/data/repositories/destination/destination_repository.dart';
import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/data/repositories/user_repository/user_repository.dart';
import 'package:architectures/data/services/activities/activities_service.dart';
import 'package:architectures/data/services/auth/auth_local_service.dart';
import 'package:architectures/data/services/auth/auth_remote_service.dart';
import 'package:architectures/data/services/auth/auth_service.dart';
import 'package:architectures/data/services/booking/booking_local_service.dart';
import 'package:architectures/data/services/booking/booking_remote_service.dart';
import 'package:architectures/data/services/booking/booking_service.dart';
import 'package:architectures/data/services/continent/continent_local_service.dart';
import 'package:architectures/data/services/continent/continent_remote_service.dart';
import 'package:architectures/data/services/continent/continent_service.dart';
import 'package:architectures/data/services/destination/destination_service.dart';
import 'package:architectures/data/services/itinerary_config_service/itinerary_config_service.dart';
import 'package:architectures/data/services/user_services/user_local_service.dart';
import 'package:architectures/data/services/user_services/user_remote_service.dart';
import 'package:architectures/data/services/user_services/user_service.dart';
import 'package:architectures/runner/models/dependency_container.dart';
import 'package:architectures/ui/activities/controllers/activities_controller.dart';
import 'package:architectures/ui/booking/controller/booking_controller.dart';
import 'package:architectures/ui/home/controller/home_controller.dart';
import 'package:architectures/ui/logout/controllers/logout_controller.dart';
import 'package:architectures/ui/results/controllers/result_controller.dart';
import 'package:architectures/ui/search_from/controller/search_form_controller.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:architectures/utils/shared_preferences_helper.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<DependencyContainer> composeDependencies({required Logger logger}) async {
  final sharedPreferencesHelper = SharedPreferencesHelper(
    sharedPreferences: await SharedPreferences.getInstance(),
  );

  final dependencyContainer = DependencyContainer(
    homeController: homeControllerFactory(sharedPreferencesHelper: sharedPreferencesHelper),
    logoutController: logoutController(sharedPreferencesHelper: sharedPreferencesHelper),
    resultController: resultController(
      logger: logger,
      sharedPreferencesHelper: sharedPreferencesHelper,
    ),
    searchFormController: searchFormController(
      logger: logger,
      sharedPreferencesHelper: sharedPreferencesHelper,
    ),

    activitiesController: activitiesController(
      logger: logger,
      sharedPreferencesHelper: sharedPreferencesHelper,
    ),

    bookingController: bookingController(
      logger: logger,
      sharedPreferencesHelper: sharedPreferencesHelper,
    ),

    sharedPreferencesHelper: sharedPreferencesHelper,
    logger: logger,
  );
  return dependencyContainer;
}

// if it's necessary somewhere else

IAuthRepository authRepository({required SharedPreferencesHelper sharedPreferencesHelper}) {
  final mainUrl = const String.fromEnvironment("MAIN_URL");
  final IAuthService authRemoteService = AuthRemoteService(mainUrl: mainUrl);
  final IAuthService authLocalService = AuthLocalService(
    sharedPreferencesHelper: sharedPreferencesHelper,
  );
  final internetConnectionCheckerHelper = InternetConnectionCheckerHelper();
  return AuthRepositoryImpl(
    authRemoteService: authRemoteService,
    authLocalService: authLocalService,
    internetConnectionCheckerHelper: internetConnectionCheckerHelper,
  );
}

// if it's necessary somewhere else
IBookingRepository bookingRepositoryFactory({
  required SharedPreferencesHelper sharedPreferencesHelper,
}) {
  final mainUrl = const String.fromEnvironment("MAIN_URL");
  log("main url is: $mainUrl");
  final IBookingService bookingRemoteService = BookingRemoteService(mainUrl: mainUrl);
  final IBookingService bookingLocalService = BookingLocalService(
    sharedPreferencesHelper: sharedPreferencesHelper,
  );
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
IContinentRepository continentRepository({
  required SharedPreferencesHelper sharedPreferencesHelper,
}) {
  final mainUrl = const String.fromEnvironment("MAIN_URL");
  final IContinentService continentRemoteService = ContinentRemoteService(mainUrl: mainUrl);
  final IContinentService continentLocalService = ContinentLocalService(
    sharedPreferencesHelper: sharedPreferencesHelper,
  );
  final internetConnectionCheckerHelper = InternetConnectionCheckerHelper();

  return ContinentRepositoryImpl(
    continentRemoteService: continentRemoteService,
    continentLocalService: continentLocalService,
    internetConnectionCheckerHelper: internetConnectionCheckerHelper,
  );
}

IItineraryConfigRepository itineraryConfigRepository({
  required Logger logger,
  required SharedPreferencesHelper sharedPreferencesHelper,
}) {
  final IItineraryConfigService iItineraryConfigService = ItineraryConfigServiceImpl(
    logger: logger,
    sharedPreferencesHelper: sharedPreferencesHelper,
  );
  return ItineraryConfigRepositoryImpl(iItineraryConfigService: iItineraryConfigService);
}

IDestinationRepository destinationRepository({
  required SharedPreferencesHelper sharedPreferencesHelper,
}) {
  final String mainUrl = const String.fromEnvironment("MAIN_URL");
  final IDestinationService destinationRemoteService = DestinationRemoteService(mainUrl: mainUrl);
  final IDestinationService destinationLocalService = DestinationLocalService(
    sharedPreferencesHelper: sharedPreferencesHelper,
  );
  final internetConnectionCheckerHelper = InternetConnectionCheckerHelper();

  return DestinationRepositoryImpl(
    destinationRemoteService: destinationRemoteService,
    destinationLocalService: destinationLocalService,
    internetConnectionCheckerHelper: internetConnectionCheckerHelper,
  );
}

IActivitiesRepository activitiesRepository({
  required SharedPreferencesHelper sharedPreferencesHelper,
}) {
  final String mainUrl = const String.fromEnvironment("MAIN_URL");
  final IActivitiesService activitiesRemoteService = ActivitiesRemoteService(mainUrl: mainUrl);
  final IActivitiesService activitiesLocalService = ActivitiesLocalService(
    sharedPreferencesHelper: sharedPreferencesHelper,
  );
  final internetConnectionCheckerHelper = InternetConnectionCheckerHelper();
  return ActivitiesRepositoryImpl(
    activitiesRemoteService: activitiesRemoteService,
    activitiesLocalService: activitiesLocalService,
    internetConnectionChecker: internetConnectionCheckerHelper,
  );
}

LogoutController logoutController({required SharedPreferencesHelper sharedPreferencesHelper}) {
  return LogoutController(
    authRepository: authRepository(sharedPreferencesHelper: sharedPreferencesHelper),
  );
}

SearchFormController searchFormController({
  required Logger logger,
  required SharedPreferencesHelper sharedPreferencesHelper,
}) {
  return SearchFormController(
    continentRepository: continentRepository(sharedPreferencesHelper: sharedPreferencesHelper),
    itineraryConfigRepository: itineraryConfigRepository(
      logger: logger,
      sharedPreferencesHelper: sharedPreferencesHelper,
    ),
    logger: logger,
  );
}

HomeController homeControllerFactory({required SharedPreferencesHelper sharedPreferencesHelper}) {
  return HomeController(
    bookingRepository: bookingRepositoryFactory(sharedPreferencesHelper: sharedPreferencesHelper),
    userRepository: userRepositoryFactory(),
  );
}

ResultController resultController({
  required Logger logger,
  required SharedPreferencesHelper sharedPreferencesHelper,
}) {
  return ResultController(
    destinationRepository: destinationRepository(sharedPreferencesHelper: sharedPreferencesHelper),
    itineraryConfigRepository: itineraryConfigRepository(
      logger: logger,
      sharedPreferencesHelper: sharedPreferencesHelper,
    ),
    logger: logger,
  );
}

ActivitiesController activitiesController({
  required Logger logger,
  required SharedPreferencesHelper sharedPreferencesHelper,
}) {
  return ActivitiesController(
    activityRepository: activitiesRepository(sharedPreferencesHelper: sharedPreferencesHelper),
    itineraryConfigRepository: itineraryConfigRepository(
      logger: logger,
      sharedPreferencesHelper: sharedPreferencesHelper,
    ),
    logger: logger,
  );
}

BookingController bookingController({
  required Logger logger,
  required SharedPreferencesHelper sharedPreferencesHelper,
}) {
  return BookingController(
    itineraryConfigRepository: itineraryConfigRepository(
      logger: logger,
      sharedPreferencesHelper: sharedPreferencesHelper,
    ),
    bookingRepository: bookingRepositoryFactory(sharedPreferencesHelper: sharedPreferencesHelper),
    destinationRepository: destinationRepository(sharedPreferencesHelper: sharedPreferencesHelper),
    activitiesRepository: activitiesRepository(sharedPreferencesHelper: sharedPreferencesHelper),
    logger: logger,
  );
}

Logger appLogger(LogFilter logFilter) {
  final logger = Logger(
    filter: logFilter,
    printer: PrettyPrinter(
      methodCount: 2,
      // Number of method calls to be displayed
      errorMethodCount: 8,
      // Number of method calls if stacktrace is provided
      lineLength: 120,

      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      // Should each log print contain a timestamp
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    output: ConsoleOutput(),
  );

  return logger;
}

final class NoOpLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return false;
  }
}
