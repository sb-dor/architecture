import 'package:architectures/data/repositories/activities/activities_repository.dart';
import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/data/services/activities/activities_service.dart';
import 'package:architectures/data/services/itinerary_config_service/itinerary_config_service.dart';
import 'package:architectures/runner/models/dependency_container.dart';
import 'package:architectures/ui/activities/controllers/activities_controller.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
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
    testWidgets('Activities selection test', (tester) async {});
  });
}
