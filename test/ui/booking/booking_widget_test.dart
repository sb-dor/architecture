import 'package:architectures/data/repositories/activities/activities_repository.dart';
import 'package:architectures/data/repositories/booking/booking_repository.dart';
import 'package:architectures/data/repositories/destination/destination_repository.dart';
import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/data/services/activities/activities_service.dart';
import 'package:architectures/data/services/booking/booking_service.dart';
import 'package:architectures/data/services/destination/destination_service.dart';
import 'package:architectures/data/services/itinerary_config_service/itinerary_config_service.dart';
import 'package:architectures/runner/models/dependency_container.dart';
import 'package:architectures/ui/booking/controller/booking_controller.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../testing_data/temp_data/fake_activities.dart';
import '../../../testing_data/temp_data/fake_destination.dart';
import '../../../testing_data/temp_data/fake_itinerary_config.dart';
import '../../helpers/test_widget_controller.dart';
import 'booking_widget_test.mocks.dart';

final class TestBookingDependencyContainer extends TestDependencyContainer {
  TestBookingDependencyContainer({required BookingController bookingController})
    : _bookingController = bookingController;

  final BookingController _bookingController;

  @override
  BookingController get bookingController => _bookingController;
}

@GenerateMocks([
  IItineraryConfigService,
  IBookingService,
  IDestinationService,
  IActivitiesService,
  InternetConnectionCheckerHelper,
])
void main() {
  late final MockIItineraryConfigService mockIItineraryConfigService;
  late final MockIBookingService mockIBookingRemoteService;
  late final MockIBookingService mockIBookingLocalService;
  late final MockIDestinationService mockIDestinationRemoteService;
  late final MockIDestinationService mockIDestinationLocalService;
  late final MockIActivitiesService mockIActivitiesRemoteService;
  late final MockIActivitiesService mockIActivitiesLocalService;
  late final MockInternetConnectionCheckerHelper mockInternetConnectionCheckerHelper;

  late final BookingController bookingController;

  setUpAll(() {
    mockIItineraryConfigService = MockIItineraryConfigService();
    mockIBookingRemoteService = MockIBookingService();
    mockIBookingLocalService = MockIBookingService();
    mockIDestinationRemoteService = MockIDestinationService();
    mockIDestinationLocalService = MockIDestinationService();
    mockIActivitiesRemoteService = MockIActivitiesService();
    mockIActivitiesLocalService = MockIActivitiesService();
    mockInternetConnectionCheckerHelper = MockInternetConnectionCheckerHelper();

    final IItineraryConfigRepository itineraryConfigRepository = ItineraryConfigRepositoryImpl(
      iItineraryConfigService: mockIItineraryConfigService,
    );

    final IBookingRepository bookingRepository = BookingRepositoryImpl(
      bookingRemoteService: mockIBookingRemoteService,
      bookingLocalService: mockIBookingLocalService,
      internetConnectionCheckerHelper: mockInternetConnectionCheckerHelper,
    );

    final IDestinationRepository destinationRepository = DestinationRepositoryImpl(
      destinationRemoteService: mockIDestinationRemoteService,
      destinationLocalService: mockIDestinationLocalService,
      internetConnectionCheckerHelper: mockInternetConnectionCheckerHelper,
    );

    final IActivitiesRepository activitiesRepository = ActivitiesRepositoryImpl(
      activitiesRemoteService: mockIActivitiesRemoteService,
      activitiesLocalService: mockIActivitiesLocalService,
      internetConnectionChecker: mockInternetConnectionCheckerHelper,
    );

    bookingController = BookingController(
      itineraryConfigRepository: itineraryConfigRepository,
      bookingRepository: bookingRepository,
      destinationRepository: destinationRepository,
      activitiesRepository: activitiesRepository,
      logger: Logger(),
    );
  });

  group('Booking widget test', () {
    //
    testWidgets('Booking test widget without sending id to the widget', (tester) async {
      when(mockInternetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);

      when(
        mockIItineraryConfigService.getItineraryConfig(),
      ).thenAnswer((_) async => fakeItineraryConfig);

      when(
        mockIDestinationRemoteService.getDestinations(),
      ).thenAnswer((_) async => [kDestination1, kDestination2]);

      when(
        mockIActivitiesRemoteService.getByDestination(any),
      ).thenAnswer((_) async => [kActivity]);

      when(mockIBookingRemoteService.createBooking(any));
    });
  });
}
