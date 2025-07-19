import 'package:architectures/data/repositories/destination/destination_repository.dart';
import 'package:architectures/data/services/destination/destination_service.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../testing_data/temp_data/fake_destination.dart';
import 'destination_repository_test.mocks.dart';

@GenerateMocks([IDestinationService, InternetConnectionCheckerHelper])
void main() {
  late final MockIDestinationService mockIDestinationRemoteService;
  late final MockIDestinationService mockIDestinationLocalService;
  late final MockInternetConnectionCheckerHelper mockInternetConnectionCheckerHelper;

  late final IDestinationRepository destinationRepository;

  setUpAll(() {
    mockIDestinationRemoteService = MockIDestinationService();
    mockIDestinationLocalService = MockIDestinationService();
    mockInternetConnectionCheckerHelper = MockInternetConnectionCheckerHelper();

    destinationRepository = DestinationRepositoryImpl(
      destinationRemoteService: mockIDestinationRemoteService,
      destinationLocalService: mockIDestinationLocalService,
      internetConnectionCheckerHelper: mockInternetConnectionCheckerHelper,
    );
  });

  group('Remote test', () {
    //
    test('Test getDestination for success', () async {
      // arrange
      when(mockInternetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);
      when(
        mockIDestinationRemoteService.getDestinations(),
      ).thenAnswer((_) async => [kDestination1, kDestination2]);

      // act
      final destinations = await destinationRepository.getDestinations();

      // asset
      expect(destinations, isNotEmpty);
      verify(mockInternetConnectionCheckerHelper.hasAccessToInternet()).called(1);
      verify(mockIDestinationRemoteService.getDestinations()).called(1);
    });

    //
    test('Test getDestination for failure', () async {
      // arrange
      when(mockInternetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);
      when(mockIDestinationRemoteService.getDestinations()).thenThrow(Exception());

      // act
      final destinations = destinationRepository.getDestinations();

      // asset
      expect(destinations, throwsException);
      verify(mockInternetConnectionCheckerHelper.hasAccessToInternet()).called(1);
    });
  });

  group('Local test', () {
    //
    test('Test getDestination for success', () async {
      // arrange
      when(mockInternetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => false);
      when(
        mockIDestinationLocalService.getDestinations(),
      ).thenAnswer((_) async => [kDestination1, kDestination2]);

      // act
      final destinations = await destinationRepository.getDestinations();

      // asset
      expect(destinations, isNotEmpty);
      verify(mockInternetConnectionCheckerHelper.hasAccessToInternet()).called(1);
      verify(mockIDestinationLocalService.getDestinations()).called(1);
    });

    //
    test('Test getDestination for failure', () async {
      // arrange
      when(mockInternetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => false);
      when(mockIDestinationLocalService.getDestinations()).thenThrow(Exception());

      // act
      final destinations = destinationRepository.getDestinations();

      // asset
      expect(destinations, throwsException);
      verify(mockInternetConnectionCheckerHelper.hasAccessToInternet()).called(1);
    });
  });
}
