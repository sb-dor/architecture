import 'package:architectures/data/repositories/activities/activities_repository.dart';
import 'package:architectures/data/repositories/booking/booking_repository.dart';
import 'package:architectures/data/repositories/destination/destination_repository.dart';
import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/data/services/activities/activities_service.dart';
import 'package:architectures/data/services/booking/booking_service.dart';
import 'package:architectures/data/services/destination/destination_service.dart';
import 'package:architectures/data/services/itinerary_config_service/itinerary_config_service.dart';
import 'package:architectures/models/itinerary_config.dart';
import 'package:architectures/runner/models/dependency_container.dart';
import 'package:architectures/runner/widgets/dependencies_scope.dart';
import 'package:architectures/ui/booking/controller/booking_controller.dart';
import 'package:architectures/ui/booking/widgets/booking_widget.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test/helpers/test_widget_controller.dart';
import '../../testing_data/temp_data/fake_activities.dart';
import '../../testing_data/temp_data/fake_destination.dart';
import 'booking_integration_test.mocks.dart';

@GenerateMocks([
  IItineraryConfigService,
  IBookingService,
  IDestinationService,
  IActivitiesService,
  InternetConnectionCheckerHelper,
])
void main() {
  final fakeItineraryConfig = ItineraryConfig(
    continent: 'Europe',
    startDate: DateTime(2024, 01, 01),
    endDate: DateTime(2024, 01, 31),
    guests: 2,
    destination: 'DESTINATION',
    activities: fakeActivities.map((el) => el.ref).toList(),
  );

  late final Widget app;
  late final MockIItineraryConfigService mockIItineraryConfigService;

  late final MockIBookingService mockBookingRemoteService;
  late final MockIBookingService mockBookingLocalService;

  late final MockIDestinationService mockDestinationRemoteService;
  late final MockIDestinationService mockDestinationLocalService;

  late final MockIActivitiesService mockActivitiesRemoteService;
  late final MockIActivitiesService mockActivitiesLocalService;

  late final MockInternetConnectionCheckerHelper mockInternetConnectionCheckerHelper;
  late final BookingController bookingController;

  setUpAll(() {
    mockIItineraryConfigService = MockIItineraryConfigService();

    mockBookingRemoteService = MockIBookingService();
    mockBookingLocalService = MockIBookingService();

    mockDestinationRemoteService = MockIDestinationService();
    mockDestinationLocalService = MockIDestinationService();

    mockActivitiesRemoteService = MockIActivitiesService();
    mockActivitiesLocalService = MockIActivitiesService();

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
      destinationRemoteService: mockDestinationRemoteService,
      destinationLocalService: mockDestinationLocalService,
      internetConnectionCheckerHelper: mockInternetConnectionCheckerHelper,
    );

    final IActivitiesRepository activitiesRepository = ActivitiesRepositoryImpl(
      activitiesRemoteService: mockActivitiesRemoteService,
      activitiesLocalService: mockActivitiesLocalService,
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

  group('Booking group integration test', () {
    //
    testWidgets('Booking integration test', (tester) async {
      when(mockInternetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);

      when(
        mockDestinationRemoteService.getDestinations(),
      ).thenAnswer((_) async => kTestDestinations);

      when(
        mockIItineraryConfigService.getItineraryConfig(),
      ).thenAnswer((_) async => fakeItineraryConfig);

      when(
        mockActivitiesRemoteService.getByDestination("DESTINATION"),
      ).thenAnswer((_) async => fakeActivities);

      when(mockBookingRemoteService.createBooking(any)).thenAnswer((_) async => true);

      //
      await TestWidgetController(tester).pumpWidget(
        BookingWidget(),
        dependencies: TestDependenciesContainer(bookingController: bookingController),
      );

      await tester.pumpAndSettle();

      final findShareButton = find.byKey(ValueKey<String>("share-button"));

      final findSeveralBookingActivity = find.byWidgetPredicate(
        (el) =>
            el.key != null &&
            el.key is ValueKey<String> &&
            (el.key as ValueKey<String>).value.contains("booking_activity_"),
      );

      expect(findShareButton, findsOneWidget);
      expect(findSeveralBookingActivity, findsWidgets);
    });
  });
}

class TestIntegrationWidget extends StatelessWidget {
  const TestIntegrationWidget({super.key, required this.dependencyContainer, required this.widget});

  final DependencyContainer dependencyContainer;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return DependenciesScope(dependencies: dependencyContainer, child: widget);
  }
}

final class TestDependenciesContainer extends TestDependencyContainer {
  TestDependenciesContainer({required BookingController bookingController})
    : _bookingController = bookingController;

  final BookingController _bookingController;

  @override
  BookingController get bookingController => _bookingController;
}
