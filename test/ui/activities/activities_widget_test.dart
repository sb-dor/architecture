import 'package:architectures/data/repositories/activities/activities_repository.dart';
import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/data/services/activities/activities_service.dart';
import 'package:architectures/data/services/itinerary_config_service/itinerary_config_service.dart';
import 'package:architectures/runner/models/dependency_container.dart';
import 'package:architectures/ui/activities/controllers/activities_controller.dart';
import 'package:architectures/ui/activities/widgets/activities_widget.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../testing_data/temp_data/fake_activities.dart';
import '../../../testing_data/temp_data/fake_destination.dart';
import '../../../testing_data/temp_data/fake_itinerary_config.dart';
import '../../helpers/test_widget_controller.dart';
import 'activities_widget_test.mocks.dart';

final class TestActivitiesDependencyContainer extends TestDependencyContainer {
  TestActivitiesDependencyContainer({required ActivitiesController activitiesController})
    : _activitiesController = activitiesController;

  final ActivitiesController _activitiesController;

  @override
  ActivitiesController get activitiesController => _activitiesController;
}

@GenerateMocks([IActivitiesService, IItineraryConfigService, InternetConnectionCheckerHelper])
void main() {
  late final MockIActivitiesService mockIActivitiesRemoteService;
  late final MockIActivitiesService mockIActivitiesLocalService;
  late final MockIItineraryConfigService mockIItineraryConfigService;
  late final MockInternetConnectionCheckerHelper mockInternetConnectionCheckerHelper;

  late final ActivitiesController activitiesController;

  setUpAll(() {
    mockIActivitiesRemoteService = MockIActivitiesService();
    mockIActivitiesLocalService = MockIActivitiesService();
    mockIItineraryConfigService = MockIItineraryConfigService();
    mockInternetConnectionCheckerHelper = MockInternetConnectionCheckerHelper();

    final IActivitiesRepository activitiesRepository = ActivitiesRepositoryImpl(
      activitiesRemoteService: mockIActivitiesRemoteService,
      activitiesLocalService: mockIActivitiesLocalService,
      internetConnectionChecker: mockInternetConnectionCheckerHelper,
    );

    final IItineraryConfigRepository itineraryConfigRepository = ItineraryConfigRepositoryImpl(
      iItineraryConfigService: mockIItineraryConfigService,
    );

    activitiesController = ActivitiesController(
      activityRepository: activitiesRepository,
      itineraryConfigRepository: itineraryConfigRepository,
      logger: Logger(),
    );
  });

  group('Activities Widget Test', () {
    testWidgets('Activities selection test', (tester) async {
      when(mockInternetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);

      when(
        mockIItineraryConfigService.getItineraryConfig(),
      ).thenAnswer((_) async => fakeItineraryConfig);

      when(mockIActivitiesRemoteService.getByDestination(any)).thenAnswer((_) async => [kActivity]);

      await TestWidgetController(tester).pumpWidget(
        ActivitiesWidget(),
        dependencies: TestActivitiesDependencyContainer(activitiesController: activitiesController),
      );

      await activitiesController.loadActivities();

      await tester.pumpAndSettle();

      final findSeveralWidgets = find.byWidgetPredicate((widget) {
        return widget.key != null &&
            widget.key is ValueKey<String> &&
            (widget.key as ValueKey<String>).value.contains("activities_item_");
      });

      expect(findSeveralWidgets, findsWidgets);
    });
  });
}
