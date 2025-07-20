import 'dart:convert';

import 'package:architectures/data/services/continent/continent_local_service.dart';
import 'package:architectures/data/services/continent/continent_service.dart';
import 'package:architectures/models/continent.dart';
import 'package:architectures/utils/shared_preferences_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../testing_data/temp_data/fake_continents.dart';
import 'continent_local_service_test.mocks.dart';

@GenerateMocks([SharedPreferencesHelper])
void main() {
  late final MockSharedPreferencesHelper mockSharedPreferencesHelper;

  late final IContinentService continentLocalService;

  final Map<String, dynamic> success = {
    "success": true,
    "continents": fakeContinents.map((element) => element.toJson()).toList(),
  };

  final Map<String, dynamic> success2 = {
    "success": true,
    "continents": <Continent>[],
  };

  setUpAll(() {
    mockSharedPreferencesHelper = MockSharedPreferencesHelper();

    continentLocalService = ContinentLocalService(
      sharedPreferencesHelper: mockSharedPreferencesHelper,
    );
  });

  group('Test ContinentLocalService', () {
    //
    test('test get getContinents for success', () async {
      when(mockSharedPreferencesHelper.getString(any)).thenReturn(jsonEncode(success));

      final continents = await continentLocalService.getContinents();

      expect(continents, isNotEmpty);
      verify(mockSharedPreferencesHelper.getString(any)).called(1);
    });

    //
    test('test get getContinents for failure', () async {
      when(mockSharedPreferencesHelper.getString(any)).thenReturn(null);

      final continents = await continentLocalService.getContinents();

      expect(continents, isEmpty);
      verify(mockSharedPreferencesHelper.getString(any)).called(1);
    });


    //
    test('test get getContinents for success but with empty data', () async {
      when(mockSharedPreferencesHelper.getString(any)).thenReturn(jsonEncode(success2));

      final continents = await continentLocalService.getContinents();

      expect(continents, isEmpty);
      verify(mockSharedPreferencesHelper.getString(any)).called(1);
    });
  });
}
