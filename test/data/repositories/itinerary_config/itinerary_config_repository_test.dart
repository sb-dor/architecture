import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/data/services/itinerary_config_service/itinerary_config_service.dart';
import 'package:architectures/models/itinerary_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../testing_data/temp_data/fake_itinerary_config.dart';
import 'itinerary_config_repository_test.mocks.dart';

@GenerateMocks([IItineraryConfigService])
void main() {
  final tempItineraryConfig = ItineraryConfig();

  late final MockIItineraryConfigService mockIItineraryConfigService;

  late final IItineraryConfigRepository iItineraryConfigRepository;

  setUpAll(() {
    mockIItineraryConfigService = MockIItineraryConfigService();

    iItineraryConfigRepository = ItineraryConfigRepositoryImpl(
      iItineraryConfigService: mockIItineraryConfigService,
    );
  });

  group("IItineraryConfigRepository Test", () {
    //
    test('Itinerary config returns config', () async {
      //
      when(
        mockIItineraryConfigService.getItineraryConfig(),
      ).thenAnswer((_) async => fakeItineraryConfig);

      final itineraryConfig = await iItineraryConfigRepository.getItineraryConfig();

      expect(itineraryConfig, isNotNull);
      verify(mockIItineraryConfigService.getItineraryConfig()).called(1);
    });

    //
    test('Itinerary config returns null', () async {
      //
      when(
        mockIItineraryConfigService.getItineraryConfig(),
      ).thenAnswer((_) async => tempItineraryConfig);

      final itineraryConfig = await iItineraryConfigRepository.getItineraryConfig();

      expect(itineraryConfig.isConfigEmpty, isTrue);
      verify(mockIItineraryConfigService.getItineraryConfig()).called(1);
    });

    //
    test('Test - Saving itinerary config completes', () async {
      //
      when(
        mockIItineraryConfigService.setItineraryConfig(any),
      ).thenAnswer((_) async => Future.value());

      final itineraryConfig = iItineraryConfigRepository.setItineraryConfig(tempItineraryConfig);

      expect(itineraryConfig, completes);
      verify(mockIItineraryConfigService.setItineraryConfig(any)).called(1);
    });
  });
}
