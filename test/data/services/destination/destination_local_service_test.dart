import 'dart:convert';
import 'package:architectures/data/services/destination/destination_service.dart';
import 'package:architectures/models/destination.dart';
import 'package:architectures/utils/shared_preferences_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../testing_data/temp_data/fake_destination.dart';
import 'destination_local_service_test.mocks.dart';

@GenerateMocks([SharedPreferencesHelper])
void main() {
  final fakeDestinations = <Destination>[kDestination1, kDestination2];

  final successResult = <String, dynamic>{"continents": fakeDestinations};
  final emptyResult = <String, dynamic>{"continents": <Destination>[]};

  late final MockSharedPreferencesHelper mockSharedPreferencesHelper;

  late final IDestinationService destinationService;

  setUpAll(() {
    mockSharedPreferencesHelper = MockSharedPreferencesHelper();

    destinationService = DestinationLocalService(
      sharedPreferencesHelper: mockSharedPreferencesHelper,
    );
  });

  group('Destination Local Service Test', () {
    //
    test('Test getDestinations for success', () async {
      //
      when(mockSharedPreferencesHelper.getString(any)).thenReturn(jsonEncode(successResult));

      final destinations = await destinationService.getDestinations();

      expect(destinations, isNotEmpty);
      verify(mockSharedPreferencesHelper.getString(any)).called(1);
    });

    //
    test('Test getDestinations for empty - null', () async {
      //
      when(mockSharedPreferencesHelper.getString(any)).thenReturn(jsonEncode(emptyResult));

      final destinations = await destinationService.getDestinations();

      expect(destinations, isEmpty);
      verify(mockSharedPreferencesHelper.getString(any)).called(1);
    });

    //
    test('Test getDestinations for empty - empty array', () async {
      //
      when(mockSharedPreferencesHelper.getString(any)).thenReturn(null);

      final destinations = await destinationService.getDestinations();

      expect(destinations, isEmpty);
      verify(mockSharedPreferencesHelper.getString(any)).called(1);
    });
  });
}
