import 'package:architectures/data/repositories/destination/destination_repository.dart';
import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/data/services/destination/destination_service.dart';
import 'package:architectures/data/services/itinerary_config_service/itinerary_config_service.dart';
import 'package:architectures/runner/models/dependency_container.dart';
import 'package:architectures/ui/results/controllers/result_controller.dart';
import 'package:architectures/ui/results/widgets/result_widget.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../testing_data/temp_data/fake_destination.dart';
import '../../../testing_data/temp_data/fake_itinerary_config.dart';
import '../../helpers/test_widget_controller.dart';
import 'results_widget_test.mocks.dart';

final class TestResultsDependencyContainer extends TestDependencyContainer {
  TestResultsDependencyContainer({required ResultController resultController})
    : _resultController = resultController;

  final ResultController _resultController;

  @override
  ResultController get resultController => _resultController;
}

@GenerateMocks([IDestinationService, IItineraryConfigService, InternetConnectionCheckerHelper])
void main() {
  late final MockIDestinationService mockIDestinationRemoteService;
  late final MockIDestinationService mockIDestinationLocalService;
  late final MockIItineraryConfigService mockIItineraryConfigService;
  late final MockInternetConnectionCheckerHelper internetConnectionCheckerHelper;
  late final ResultController resultController;

  setUpAll(() {
    mockIDestinationRemoteService = MockIDestinationService();
    mockIDestinationLocalService = MockIDestinationService();
    mockIItineraryConfigService = MockIItineraryConfigService();
    internetConnectionCheckerHelper = MockInternetConnectionCheckerHelper();

    final IDestinationRepository destinationRepository = DestinationRepositoryImpl(
      destinationRemoteService: mockIDestinationRemoteService,
      destinationLocalService: mockIDestinationLocalService,
      internetConnectionCheckerHelper: internetConnectionCheckerHelper,
    );

    final IItineraryConfigRepository itineraryConfigRepository = ItineraryConfigRepositoryImpl(
      iItineraryConfigService: mockIItineraryConfigService,
    );

    resultController = ResultController(
      destinationRepository: destinationRepository,
      itineraryConfigRepository: itineraryConfigRepository,
      logger: Logger(),
    );
  });

  group('Results Widget Test', () {
    testWidgets('Test loading of destinations', (tester) async {
      when(internetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);

      when(
        mockIDestinationRemoteService.getDestinations(),
      ).thenAnswer((_) async => [kDestination1, kDestination2]);

      when(
        mockIItineraryConfigService.getItineraryConfig(),
      ).thenAnswer((_) async => fakeItineraryConfig);

      await TestWidgetController(tester).pumpWidget(
        ResultWidget(),
        dependencies: TestResultsDependencyContainer(resultController: resultController),
      );

      await resultController.search();

      await tester.pumpAndSettle();

      final findSeveralWidgets = find.byWidgetPredicate(
        (widget) =>
            widget.key != null &&
            widget.key is ValueKey<String> &&
            (widget.key as ValueKey<String>).value.contains("result_destination_"),
      );

      expect(findSeveralWidgets, findsWidgets);

      expect(resultController.destinations.isNotEmpty, true);

      verify(mockIDestinationRemoteService.getDestinations());

      verify(mockIItineraryConfigService.getItineraryConfig());
    });
  });
}
