import 'package:architectures/data/repositories/continent/continent_repository.dart';
import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/data/services/continent/continent_service.dart';
import 'package:architectures/data/services/itinerary_config_service/itinerary_config_service.dart';
import 'package:architectures/runner/models/dependency_container.dart';
import 'package:architectures/ui/search_from/controller/search_form_controller.dart';
import 'package:architectures/ui/search_from/widgets/search_form_widget.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../testing_data/temp_data/fake_continents.dart';
import '../../../testing_data/temp_data/fake_itinerary_config.dart';
import 'search_form_widget_test.mocks.dart';

import '../../helpers/test_widget_controller.dart' as tcontroller;

final class TestSearchFromDependencyContainer extends TestDependencyContainer {
  TestSearchFromDependencyContainer({required SearchFormController searchFormController})
    : _searchFormController = searchFormController;

  final SearchFormController _searchFormController;

  @override
  SearchFormController get searchFormController => _searchFormController;
}

@GenerateMocks([IItineraryConfigService, IContinentService, InternetConnectionCheckerHelper])
void main() {
  late final MockIContinentService mockIContinentRemoteService;
  late final MockIContinentService mockIContinentLocalService;
  late final MockIItineraryConfigService mockIItineraryConfigService;
  late final MockInternetConnectionCheckerHelper internetConnectionCheckerHelper;
  final Logger logger = Logger();

  late final SearchFormController searchFormController;

  setUpAll(() {
    mockIContinentRemoteService = MockIContinentService();
    mockIContinentLocalService = MockIContinentService();
    mockIItineraryConfigService = MockIItineraryConfigService();
    internetConnectionCheckerHelper = MockInternetConnectionCheckerHelper();

    final IItineraryConfigRepository itineraryConfigRepository = ItineraryConfigRepositoryImpl(
      iItineraryConfigService: mockIItineraryConfigService,
    );

    final IContinentRepository iContinentRepository = ContinentRepositoryImpl(
      continentRemoteService: mockIContinentRemoteService,
      continentLocalService: mockIContinentLocalService,
      internetConnectionCheckerHelper: internetConnectionCheckerHelper,
    );

    searchFormController = SearchFormController(
      continentRepository: iContinentRepository,
      itineraryConfigRepository: itineraryConfigRepository,
      logger: logger,
    );
  });

  group('description', () {
    testWidgets('Search Multiple Continents', (tester) async {
      when(internetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);

      when(mockIContinentRemoteService.getContinents()).thenAnswer((_) async => fakeContinents);

      when(
        mockIItineraryConfigService.getItineraryConfig(),
      ).thenAnswer((_) async => fakeItineraryConfig);

      await tcontroller.TestWidgetController(tester).pumpWidget(
        SearchFormWidget(),
        dependencies: TestSearchFromDependencyContainer(
          searchFormController: searchFormController,
        ),
      );

      expect(searchFormController.continents.isNotEmpty, true);

      await tester.pumpAndSettle();

      final findSeveralContinents = find.byWidgetPredicate((widget) {
        return widget.key != null &&
            widget.key is ValueKey<String> &&
            (widget.key as ValueKey<String>).value.contains('continent_key_name_');
      });

      expect(findSeveralContinents, findsWidgets);
    });

    testWidgets('Test Search FilledButton', (tester) async {
      when(internetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);

      when(mockIContinentRemoteService.getContinents()).thenAnswer((_) async => fakeContinents);

      when(
        mockIItineraryConfigService.getItineraryConfig(),
      ).thenAnswer((_) async => fakeItineraryConfig);

      await tcontroller.TestWidgetController(tester).pumpWidget(
        SearchFormWidget(),
        dependencies: TestSearchFromDependencyContainer(
          searchFormController: searchFormController,
        ),
      );

      await searchFormController.load();

      await tester.pumpAndSettle();

      final findButton = find.byType(FilledButton);
      final findTextInButton = find.text('Search selected data');

      expect(findTextInButton, findsNothing);
      expect(findButton, findsOneWidget);

      searchFormController.selectedContinent = fakeContinents.first.name;
      searchFormController.dateRange = DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(Duration(days: 10)),
      );
      searchFormController.guests = 2;

      await tester.pumpAndSettle();

      expect(findTextInButton, findsOneWidget);
    });
  });
}
