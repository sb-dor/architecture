import 'package:architectures/data/repositories/activities/activities_repository.dart';
import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/data/services/activities/activities_service.dart';
import 'package:architectures/data/services/itinerary_config_service/itinerary_config_service.dart';
import 'package:architectures/models/itinerary_config.dart';
import 'package:architectures/runner/models/dependency_container.dart';
import 'package:architectures/ui/activities/controllers/activities_controller.dart';
import 'package:architectures/ui/activities/widgets/activities_widget.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test/helpers/test_widget_controller.dart';
import '../../testing_data/temp_data/fake_activities.dart';
import 'activities_integration_test.mocks.dart';

// https://stackoverflow.com/questions/68275811/is-there-a-way-to-let-mockito-generate-mocks-for-integration-tests-in-a-flutter
@GenerateMocks([
  IActivitiesService,
  IItineraryConfigService,
  InternetConnectionCheckerHelper,
  IItineraryConfigRepository,
])
void main() {
  final fakedItineraryConfig = ItineraryConfig(
    continent: 'Europe',
    startDate: DateTime(2024, 01, 01),
    endDate: DateTime(2024, 01, 31),
    guests: 2,
    destination: 'DESTINATION',
    activities: [],
  );
  late final MockIActivitiesService mockIActivitiesRemoteService;
  late final MockIActivitiesService mockIActivitiesLocalService;
  late final MockIItineraryConfigService mockIItineraryConfigService;
  late final MockInternetConnectionCheckerHelper mockInternetConnectionCheckerHelper;

  late final ActivitiesController activitiesController;

  setUpAll(() {
    //
    mockIActivitiesRemoteService = MockIActivitiesService();
    mockIActivitiesLocalService = MockIActivitiesService();
    mockIItineraryConfigService = MockIItineraryConfigService();
    mockInternetConnectionCheckerHelper = MockInternetConnectionCheckerHelper();

    final IActivitiesRepository activitiesRepository = ActivitiesRepositoryImpl(
      activitiesRemoteService: mockIActivitiesRemoteService,
      activitiesLocalService: mockIActivitiesLocalService,
      internetConnectionChecker: mockInternetConnectionCheckerHelper,
    );

    final IItineraryConfigRepository iItineraryConfigRepository = ItineraryConfigRepositoryImpl(
      iItineraryConfigService: mockIItineraryConfigService,
    );

    activitiesController = ActivitiesController(
      activityRepository: activitiesRepository,
      itineraryConfigRepository: iItineraryConfigRepository,
      logger: Logger(),
    );
  });

  tearDownAll(() {
    activitiesController.dispose();
  });

  group('Activities integration test', () {
    //
    testWidgets('Testing activities widget - overall', (tester) async {
      when(mockInternetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);

      when(
        mockIItineraryConfigService.getItineraryConfig(),
      ).thenAnswer((_) async => fakedItineraryConfig);

      when(
        mockIActivitiesRemoteService.getByDestination(any),
      ).thenAnswer((_) async => fakeActivities);

      await TestWidgetController(tester).pumpWidget(
        ActivitiesWidget(),
        dependencies: TestDependenciesContainer(activitiesController: activitiesController),
      );

      await tester.pumpAndSettle();

      // find list - is not necessary
      final findScrollableList = find.byKey(ValueKey<String>("scrollable_activities_list"));

      // find all widgets that are rendered inside list
      final findListWidgets = find.byWidgetPredicate(
        (el) =>
            el.key != null &&
            el.key is ValueKey<String> &&
            (el.key as ValueKey<String>).value.contains("activity_checkbox_"),
      );

      final findNoSelectedItemsTest = find.text("No Selected Items");

      expect(findListWidgets, findsWidgets);
      expect(findScrollableList, findsOneWidget);
      expect(findNoSelectedItemsTest, findsOneWidget);

      for (final each in fakeActivities) {
        final activityWidget = find.byKey(ValueKey<String>("activity_checkbox_${each.ref}"));
        await tester.ensureVisible(activityWidget);
        await tester.tap(activityWidget);
        await tester.pumpAndSettle();
      }

      final findSeveralSelectedText = find.text(
        "${activitiesController.selectedActivities.length} selected",
      );

      expect(findSeveralSelectedText, findsOne);
      expect(activitiesController.selectedActivities, isNotEmpty);
      verify(mockInternetConnectionCheckerHelper.hasAccessToInternet()).called(1);
      verify(mockIActivitiesRemoteService.getByDestination(any)).called(1);
      verify(mockIItineraryConfigService.getItineraryConfig()).called(1);
    });
  });
}

final class TestDependenciesContainer extends TestDependencyContainer {
  TestDependenciesContainer({required ActivitiesController activitiesController})
    : _activitiesController = activitiesController;

  final ActivitiesController _activitiesController;

  @override
  ActivitiesController get activitiesController => _activitiesController;
}
