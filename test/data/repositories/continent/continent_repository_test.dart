import 'package:architectures/data/repositories/continent/continent_repository.dart';
import 'package:architectures/data/services/continent/continent_service.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../testing_data/temp_data/fake_continents.dart';
import 'continent_repository_test.mocks.dart';

@GenerateMocks([IContinentService, InternetConnectionCheckerHelper])
void main() {
  late final MockIContinentService continentRemoteService;
  late final MockIContinentService continentLocalService;
  late final MockInternetConnectionCheckerHelper internetConnectionCheckerHelper;

  late final IContinentRepository continentRepository;

  setUpAll(() {
    continentRemoteService = MockIContinentService();
    continentLocalService = MockIContinentService();
    internetConnectionCheckerHelper = MockInternetConnectionCheckerHelper();

    continentRepository = ContinentRepositoryImpl(
      continentRemoteService: continentRemoteService,
      continentLocalService: continentLocalService,
      internetConnectionCheckerHelper: internetConnectionCheckerHelper,
    );
  });

  group('Remote test', () {
    //
    test('Test getContinents for success', () async {
      // arrange
      when(internetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);
      when(continentRemoteService.getContinents()).thenAnswer((_) async => fakeContinents);

      // act
      final getContinents = await continentRepository.getContinents();

      // assert
      expect(getContinents, isNotEmpty);
      verify(internetConnectionCheckerHelper.hasAccessToInternet()).called(1);
      verify(continentRemoteService.getContinents()).called(1);
    });

    //
    test('Test getContinents for failure', () async {
      // arrange
      when(internetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);
      when(
        continentRemoteService.getContinents(),
      ).thenThrow(Exception()); // if you have your own written exception use them

      // act
      // do not use await cause you service will throw an exception
      final getContinents = continentRepository.getContinents();

      // assert
      expect(getContinents, throwsException);
      verify(internetConnectionCheckerHelper.hasAccessToInternet()).called(1);
    });
  });


  group('Local test', () {
    //
    test('Test getContinents for success', () async {
      // arrange
      when(internetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => false);
      when(continentLocalService.getContinents()).thenAnswer((_) async => fakeContinents);

      // act
      final getContinents = await continentRepository.getContinents();

      // assert
      expect(getContinents, isNotEmpty);
      verify(internetConnectionCheckerHelper.hasAccessToInternet()).called(1);
      verify(continentLocalService.getContinents()).called(1);
    });

    //
    test('Test getContinents for failure', () async {
      // arrange
      when(internetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => false);
      when(
        continentLocalService.getContinents(),
      ).thenThrow(Exception()); // if you have your own written exception use them

      // act
      // do not use await cause you service will throw an exception
      final getContinents = continentRepository.getContinents();

      // assert
      expect(getContinents, throwsException);
      verify(internetConnectionCheckerHelper.hasAccessToInternet()).called(1);
    });
  });
}
