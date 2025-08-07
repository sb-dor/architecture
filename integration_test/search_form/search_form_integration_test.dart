import 'package:architectures/data/repositories/continent/continent_repository.dart';
import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/data/services/continent/continent_service.dart';
import 'package:architectures/data/services/itinerary_config_service/itinerary_config_service.dart';
import 'package:architectures/runner/models/dependency_container.dart';
import 'package:architectures/ui/search_form/controller/search_form_controller.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';

import '../../test/ui/search_form/search_form_widget_test.dart';
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

  group('Search form integration test', () async {
    //
    testWidgets('Search multiple continents', (tester) async {
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
