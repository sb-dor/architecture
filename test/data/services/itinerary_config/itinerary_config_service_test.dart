import 'dart:convert';

import 'package:architectures/data/services/itinerary_config_service/itinerary_config_service.dart';
import 'package:architectures/utils/shared_preferences_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../testing_data/temp_data/fake_itinerary_config.dart';
import '../auth/auth_local_service_test.mocks.dart';

@GenerateMocks([SharedPreferencesHelper])
void main() {
  late final MockSharedPreferencesHelper mockSharedPreferencesHelper;

  late final IItineraryConfigService iItineraryConfigService;

  setUpAll(() {
    //
    mockSharedPreferencesHelper = MockSharedPreferencesHelper();

    iItineraryConfigService = ItineraryConfigServiceImpl(
      sharedPreferencesHelper: mockSharedPreferencesHelper,
      logger: Logger(),
    );
  });

  group('ItineraryConfigService getItineraryConfig Test', () {
    //
    test('getItineraryConfig test for success', () async {
      //
      when(
        mockSharedPreferencesHelper.getString(any),
      ).thenReturn(jsonEncode(fakeItineraryConfig.toJson()));

      final itineraryConfig = await iItineraryConfigService.getItineraryConfig();

      expect(itineraryConfig.isConfigEmpty, isFalse);
      verify(mockSharedPreferencesHelper.getString(any)).called(1);
    });

    //
    test('getItineraryConfig test for failure', () async {
      //
      when(mockSharedPreferencesHelper.getString(any)).thenReturn(null);

      final itineraryConfig = await iItineraryConfigService.getItineraryConfig();

      expect(itineraryConfig.isConfigEmpty, isTrue);
      verify(mockSharedPreferencesHelper.getString(any)).called(1);
    });
  });

  //
  group('ItineraryConfigService setItineraryConfig Test', () {
    //
    test('setItineraryConfig test for success', () async {
      //
      when(
        mockSharedPreferencesHelper.saveString(any, any),
      ).thenAnswer((_) => Future<void>.value());

      final itineraryConfig = iItineraryConfigService.setItineraryConfig(fakeItineraryConfig);

      expect(itineraryConfig, completes);
      verify(mockSharedPreferencesHelper.saveString(any, any)).called(1);
    });

    //
    test('setItineraryConfig test for failure', () async {
      when(mockSharedPreferencesHelper.saveString(any, any)).thenThrow(Exception());

      expect(
        () => iItineraryConfigService.setItineraryConfig(fakeItineraryConfig),
        throwsException,
      );
    });
  });
}
