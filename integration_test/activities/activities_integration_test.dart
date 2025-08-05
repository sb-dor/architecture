import 'package:architectures/data/repositories/activities/activities_repository.dart';
import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/data/services/activities/activities_service.dart';
import 'package:architectures/data/services/itinerary_config_service/itinerary_config_service.dart';
import 'package:architectures/runner/models/dependency_container.dart';
import 'package:architectures/runner/widgets/dependencies_scope.dart';
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
import '../../testing_data/temp_data/fake_itinerary_config.dart';
import 'activities_integration_test.mocks.dart';

@GenerateMocks([
  IActivitiesService,
  IItineraryConfigService,
  InternetConnectionCheckerHelper,
  IItineraryConfigRepository,
])
void main() {
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
    testWidgets('description', (tester) async {
      when(mockInternetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);

      when(
        mockIItineraryConfigService.getItineraryConfig(),
      ).thenAnswer((_) async => fakeItineraryConfig);

      when(
        mockIActivitiesRemoteService.getByDestination(any),
      ).thenAnswer((_) async => fakeActivities);

      await TestWidgetController(tester).pumpWidget(
        ActivitiesWidget(),
        dependencies: TestDependenciesContainer(activitiesController: activitiesController),
      );

      await tester.pumpAndSettle();

      // find list
      final findScrollableList = find.byKey(ValueKey<String>("scrollable_activities_list"));

      // find all widgets that are rendered inside list
      final findListWidgets = find.byWidgetPredicate(
        (el) =>
            el.key != null &&
            el.key is ValueKey<String> &&
            (el.key as ValueKey<String>).value.contains("activities_item_"),
      );

      expect(findListWidgets, findsWidgets);
      expect(findScrollableList, findsOneWidget);

      for (final each in fakeActivities) {
        final activityWidget = find.byKey(ValueKey<String>("activities_item_${each.ref}"));
        expect(activityWidget, findsOneWidget);
        await tester.ensureVisible(activityWidget);
        await tester.pumpAndSettle();
        await tester.tap(activityWidget);
      }

      expect(activitiesController.selectedActivities, isNotEmpty);
      verify(mockInternetConnectionCheckerHelper.hasAccessToInternet()).called(1);
      verify(mockIActivitiesRemoteService.getByDestination(any)).called(1);
      verify(mockIItineraryConfigService.getItineraryConfig()).called(1);
    });
  });
}

class ActivitiesIntegrationTestWidget extends StatelessWidget {
  const ActivitiesIntegrationTestWidget({
    super.key,
    required this.dependencyContainer,
    required this.widget,
  });

  final DependencyContainer dependencyContainer;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return DependenciesScope(dependencies: dependencyContainer, child: widget);
  }
}

final class TestDependenciesContainer extends TestDependencyContainer {
  TestDependenciesContainer({required ActivitiesController activitiesController})
    : _activitiesController = activitiesController;

  final ActivitiesController _activitiesController;

  @override
  ActivitiesController get activitiesController => _activitiesController;
}
