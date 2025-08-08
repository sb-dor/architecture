import 'package:architectures/data/repositories/continent/continent_repository.dart';
import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/data/services/continent/continent_service.dart';
import 'package:architectures/data/services/itinerary_config_service/itinerary_config_service.dart';
import 'package:architectures/runner/models/dependency_container.dart';
import 'package:architectures/ui/search_form/controller/search_form_controller.dart';
import 'package:architectures/ui/search_form/widgets/search_form_widget.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test/helpers/test_widget_controller.dart';
import '../../test/ui/search_form/search_form_widget_test.dart';
import '../../testing_data/temp_data/fake_continents.dart';
import '../../testing_data/temp_data/fake_itinerary_config.dart';
import 'search_form_integration_test.mocks.dart';

@GenerateMocks([IContinentService, InternetConnectionCheckerHelper, IItineraryConfigService])
void main() {
  late final MockIContinentService mockIContinentRemoteService;
  late final MockIContinentService mockIContinentLocalService;

  late final MockIItineraryConfigService mockIItineraryConfigService;

  late final MockInternetConnectionCheckerHelper internetConnectionCheckerHelper;

  late final SearchFormController searchFormController;

  setUpAll(() {
    mockIContinentRemoteService = MockIContinentService();
    mockIContinentLocalService = MockIContinentService();

    mockIItineraryConfigService = MockIItineraryConfigService();

    internetConnectionCheckerHelper = MockInternetConnectionCheckerHelper();

    final IContinentRepository continentRepository = ContinentRepositoryImpl(
      continentRemoteService: mockIContinentRemoteService,
      continentLocalService: mockIContinentLocalService,
      internetConnectionCheckerHelper: internetConnectionCheckerHelper,
    );

    final IItineraryConfigRepository itineraryConfigRepository = ItineraryConfigRepositoryImpl(
      iItineraryConfigService: mockIItineraryConfigService,
    );

    searchFormController = SearchFormController(
      continentRepository: continentRepository,
      itineraryConfigRepository: itineraryConfigRepository,
      logger: Logger(),
    );
  });

  tearDownAll(() {
    searchFormController.dispose();
  });

  group('Search form integration test', () {
    //
    testWidgets('Test search form for success', (tester) async {
      //
      when(internetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);

      when(mockIContinentRemoteService.getContinents()).thenAnswer((_) async => fakeContinents);

      await TestWidgetController(tester).pumpWidget(
        SearchFormWidget(),
        dependencies: TestSearchFromDependencyContainer(searchFormController: searchFormController),
      );

      // there is a function that searchFormController calls inside itself, that is why we have to
      // pumpAndSettle once again
      await tester.pumpAndSettle();

      final findContinents = find.byWidgetPredicate(
        (el) =>
            el.key != null &&
            el.key is ValueKey<String> &&
            (el.key as ValueKey<String>).value.contains("continent_key_name_"),
      );

      expect(findContinents, findsWidgets);
      verify(mockIContinentRemoteService.getContinents()).called(1);
      //
    });
  });
}

final class TestSearchFromDependencyContainer extends TestDependencyContainer {
  TestSearchFromDependencyContainer({required SearchFormController searchFormController})
    : _searchFormController = searchFormController;

  final SearchFormController _searchFormController;

  @override
  SearchFormController get searchFormController => _searchFormController;
}
