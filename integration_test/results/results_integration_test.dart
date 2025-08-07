import 'package:architectures/data/repositories/activities/activities_repository.dart';
import 'package:architectures/data/repositories/destination/destination_repository.dart';
import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/data/services/activities/activities_service.dart';
import 'package:architectures/data/services/destination/destination_service.dart';
import 'package:architectures/data/services/itinerary_config_service/itinerary_config_service.dart';
import 'package:architectures/runner/models/dependency_container.dart';
import 'package:architectures/ui/activities/controllers/activities_controller.dart';
import 'package:architectures/ui/results/controllers/result_controller.dart';
import 'package:architectures/ui/results/widgets/result_widget.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test/helpers/test_widget_controller.dart';
import '../../testing_data/temp_data/fake_activities.dart';
import '../../testing_data/temp_data/fake_destination.dart';
import '../../testing_data/temp_data/fake_itinerary_config.dart';
import 'results_integration_test.mocks.dart';

@GenerateMocks([
  IDestinationService,
  IItineraryConfigService,
  InternetConnectionCheckerHelper,
  IActivitiesService,
])
void main() {
  late final MockIDestinationService mockDestinationRemoteService;
  late final MockIDestinationService mockIDestinationLocalService;

  late final MockIActivitiesService mockActivitiesRemoteService;
  late final MockIActivitiesService mockActivitiesLocalService;

  late final MockIItineraryConfigService mockIItineraryConfigService;

  late final MockInternetConnectionCheckerHelper internetConnectionCheckerHelper;

  late final ResultController resultController;
  late final ActivitiesController activitiesController;

  setUpAll(() {
    mockDestinationRemoteService = MockIDestinationService();
    mockIDestinationLocalService = MockIDestinationService();

    mockActivitiesRemoteService = MockIActivitiesService();
    mockActivitiesLocalService = MockIActivitiesService();

    mockIItineraryConfigService = MockIItineraryConfigService();

    internetConnectionCheckerHelper = MockInternetConnectionCheckerHelper();

    final IDestinationRepository destinationRepository = DestinationRepositoryImpl(
      destinationRemoteService: mockDestinationRemoteService,
      destinationLocalService: mockIDestinationLocalService,
      internetConnectionCheckerHelper: internetConnectionCheckerHelper,
    );

    final IItineraryConfigRepository itineraryConfigRepository = ItineraryConfigRepositoryImpl(
      iItineraryConfigService: mockIItineraryConfigService,
    );

    final IActivitiesRepository activitiesRepository = ActivitiesRepositoryImpl(
      activitiesRemoteService: mockActivitiesRemoteService,
      activitiesLocalService: mockActivitiesLocalService,
      internetConnectionChecker: internetConnectionCheckerHelper,
    );

    final logger = Logger();

    resultController = ResultController(
      destinationRepository: destinationRepository,
      itineraryConfigRepository: itineraryConfigRepository,
      logger: logger,
    );

    activitiesController = ActivitiesController(
      activityRepository: activitiesRepository,
      itineraryConfigRepository: itineraryConfigRepository,
      logger: logger,
    );
  });

  tearDownAll(() {
    resultController.dispose();
    activitiesController.dispose();
  });

  group("Results integration test", () {
    //
    testWidgets('Search for result destinations widgets and save clicked result', (tester) async {
      //
      when(internetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);

      when(
        mockIItineraryConfigService.getItineraryConfig(),
      ).thenAnswer((_) async => fakeItineraryConfig);

      when(
        mockDestinationRemoteService.getDestinations(),
      ).thenAnswer((_) async => kTestDestinations);

      when(
        mockIItineraryConfigService.setItineraryConfig(any),
      ).thenAnswer((_) async => Future<void>.value());

      when(
        mockIItineraryConfigService.getItineraryConfig(),
      ).thenAnswer((_) async => fakeItineraryConfig);

      when(
        mockActivitiesRemoteService.getByDestination(any),
      ).thenAnswer((_) async => fakeActivities);

      await TestWidgetController(tester).pumpWidget(
        ResultWidget(),
        dependencies: TestResultsDependencyContainer(
          resultController: resultController,
          activitiesController: activitiesController,
        ),
      );

      // controller will be called so we have to call pumpAndSettle once again
      await tester.pumpAndSettle();

      expect(resultController.destinations, isNotEmpty);

      //
      final findForResultDestinations = find.byWidgetPredicate(
        (el) =>
            el.key != null &&
            el.key is ValueKey<String> &&
            (el.key as ValueKey<String>).value.contains("results_card_widget_inkwell_"),
      );

      expect(findForResultDestinations, findsWidgets);

      await tester.tap(findForResultDestinations.first);
      await tester.pumpAndSettle();

      verify(mockDestinationRemoteService.getDestinations()).called(1);
      verify(mockIItineraryConfigService.getItineraryConfig()).called(3);
      verify(mockIItineraryConfigService.setItineraryConfig(any)).called(1);
    });
  });
}

final class TestResultsDependencyContainer extends TestDependencyContainer {
  TestResultsDependencyContainer({
    required ResultController resultController,
    required ActivitiesController activitiesController,
  }) : _resultController = resultController,
       _activitiesController = activitiesController;

  final ResultController _resultController;
  final ActivitiesController _activitiesController;

  @override
  ResultController get resultController => _resultController;

  @override
  ActivitiesController get activitiesController => _activitiesController;
}
