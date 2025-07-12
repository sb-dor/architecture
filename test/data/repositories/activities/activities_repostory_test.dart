import 'package:architectures/data/repositories/activities/activities_repository.dart';
import 'package:architectures/data/services/activities/activities_service.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../testing_data/temp_data/fake_activities.dart';
import 'activities_repostory_test.mocks.dart';

@GenerateMocks([IActivitiesService, InternetConnectionCheckerHelper])
void main() async {
  late final MockIActivitiesService mockIActivitiesRemoteService;
  late final MockIActivitiesService mockIActivitiesLocalService;
  late final MockInternetConnectionCheckerHelper internetConnectionCheckerHelper;

  late final IActivitiesRepository iActivitiesRepository;

  setUpAll(() {
    mockIActivitiesRemoteService = MockIActivitiesService();
    mockIActivitiesLocalService = MockIActivitiesService();
    internetConnectionCheckerHelper = MockInternetConnectionCheckerHelper();

    iActivitiesRepository = ActivitiesRepositoryImpl(
      activitiesRemoteService: mockIActivitiesRemoteService,
      activitiesLocalService: mockIActivitiesLocalService,
      internetConnectionChecker: internetConnectionCheckerHelper,
    );
  });

  group('Activities Repository Test', () {
    //
    test('test remote with internet connection', () async {
      // Arrange
      when(internetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);
      when(mockIActivitiesRemoteService.getByDestination(any)).thenAnswer((_) async => [kActivity]);

      // Act
      final result = await iActivitiesRepository.getByDestination('ref');

      // Assert
      expect(result, isNotEmpty);
      verify(internetConnectionCheckerHelper.hasAccessToInternet()).called(1);
      verify(mockIActivitiesRemoteService.getByDestination('ref')).called(1);
    });

    //
    test('test with no internet connection', () async {
      // arrange
      when(internetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => false);
      when(mockIActivitiesLocalService.getByDestination(any)).thenAnswer((_) async => List.empty());

      // act
      final result = await iActivitiesRepository.getByDestination('ref');

      // assert
      expect(result, isEmpty);
      verify(internetConnectionCheckerHelper.hasAccessToInternet()).called(1);
      verify(mockIActivitiesLocalService.getByDestination('ref')).called(1);
    });
  });
}
