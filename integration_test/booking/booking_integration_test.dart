import 'package:architectures/data/repositories/activities/activities_repository.dart';
import 'package:architectures/data/repositories/booking/booking_repository.dart';
import 'package:architectures/data/repositories/destination/destination_repository.dart';
import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/data/services/activities/activities_service.dart';
import 'package:architectures/data/services/booking/booking_service.dart';
import 'package:architectures/data/services/destination/destination_service.dart';
import 'package:architectures/data/services/itinerary_config_service/itinerary_config_service.dart';
import 'package:architectures/ui/booking/controller/booking_controller.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';

import 'booking_integration_test.mocks.dart';

@GenerateMocks([
  IItineraryConfigService,
  IBookingService,
  IDestinationService,
  IActivitiesService,
  InternetConnectionCheckerHelper,
])
void main() {
  late final MockIItineraryConfigService mockIItineraryConfigService;

  late final MockIBookingService mockBookingRemoteService;
  late final MockIBookingService mockBookingLocalService;

  late final MockIDestinationService destinationRemoteService;
  late final MockIDestinationService destinationLocalService;

  late final MockIActivitiesService activitiesRemoteService;
  late final MockIActivitiesService activitiesLocalService;

  late final MockInternetConnectionCheckerHelper mockInternetConnectionCheckerHelper;
  late final BookingController bookingController;

  setUpAll(() {
    mockIItineraryConfigService = MockIItineraryConfigService();

    mockBookingRemoteService = MockIBookingService();
    mockBookingLocalService = MockIBookingService();

    destinationRemoteService = MockIDestinationService();
    destinationLocalService = MockIDestinationService();

    activitiesRemoteService = MockIActivitiesService();
    activitiesLocalService = MockIActivitiesService();

    mockInternetConnectionCheckerHelper = MockInternetConnectionCheckerHelper();

    final IItineraryConfigRepository iItineraryConfigRepository = ItineraryConfigRepositoryImpl(
      iItineraryConfigService: mockIItineraryConfigService,
    );

    final IBookingRepository bookingRepository = BookingRepositoryImpl(
      bookingRemoteService: mockBookingRemoteService,
      bookingLocalService: mockBookingLocalService,
      internetConnectionCheckerHelper: mockInternetConnectionCheckerHelper,
    );

    final IDestinationRepository destinationRepository = DestinationRepositoryImpl(
      destinationRemoteService: destinationRemoteService,
      destinationLocalService: destinationLocalService,
      internetConnectionCheckerHelper: mockInternetConnectionCheckerHelper,
    );

    final IActivitiesRepository activitiesRepository = ActivitiesRepositoryImpl(
      activitiesRemoteService: activitiesRemoteService,
      activitiesLocalService: activitiesLocalService,
      internetConnectionChecker: mockInternetConnectionCheckerHelper,
    );

    bookingController = BookingController(
      itineraryConfigRepository: iItineraryConfigRepository,
      bookingRepository: bookingRepository,
      destinationRepository: destinationRepository,
      activitiesRepository: activitiesRepository,
      logger: Logger(),
    );
  });

  tearDownAll(() {
    bookingController.dispose();
  });
}
