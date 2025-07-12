import 'package:architectures/data/repositories/auth/auth_repository.dart';
import 'package:architectures/data/services/auth/auth_service.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../testing_data/temp_data/fake_user.dart';
import 'auth_repository_test.mocks.dart';

@GenerateMocks([IAuthService, InternetConnectionCheckerHelper])
void main() async {
  late final MockIAuthService authRemoteService;
  late final MockIAuthService authLocalService;
  late final MockInternetConnectionCheckerHelper internetConnectionCheckerHelper;

  late final IAuthRepository iAuthRepository;

  setUpAll(() {
    authRemoteService = MockIAuthService();
    authLocalService = MockIAuthService();
    internetConnectionCheckerHelper = MockInternetConnectionCheckerHelper();

    iAuthRepository = AuthRepositoryImpl(
      authRemoteService: authRemoteService,
      authLocalService: authLocalService,
      internetConnectionCheckerHelper: internetConnectionCheckerHelper,
    );
  });

  final String userEmail = "test@gmail.com";
  final String userPassword = "12345678";

  group('Authenticated Getter Test', () {
    //
    test('Remote test', () async {
      // arrange
      when(internetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);
      when(authRemoteService.isAuthenticated).thenAnswer((_) async => true);

      // act
      final isAuthenticated = await iAuthRepository.isAuthenticated;

      // assert
      expect(isAuthenticated, true);
      verify(internetConnectionCheckerHelper.hasAccessToInternet()).called(1);
      verify(authRemoteService.isAuthenticated).called(1);
    });

    //
    test('Local Test', () async {
      // arrange
      when(internetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => false);
      when(authLocalService.isAuthenticated).thenAnswer((_) async => true);

      // act
      final isAuthenticated = await iAuthRepository.isAuthenticated;

      // assert
      expect(isAuthenticated, true);
      verify(internetConnectionCheckerHelper.hasAccessToInternet()).called(1);
      verify(authLocalService.isAuthenticated).called(1);
    });
  });

  group("Login method test", () {
    //
    test('Remote test', () async {
      // arrange
      when(internetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);
      when(
        authRemoteService.login(email: userEmail, password: userPassword),
      ).thenAnswer((_) async => kUser);

      // act
      final login = await iAuthRepository.login(email: userEmail, password: userPassword);

      // assert
      expect(login, isNotNull);
      verify(internetConnectionCheckerHelper.hasAccessToInternet()).called(1);
      verify(authRemoteService.login(email: userEmail, password: userPassword)).called(1);
    });

    //
    test('Local test', () async {
      // arrange
      when(internetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => false);
      when(
        authLocalService.login(email: userEmail, password: userPassword),
      ).thenAnswer((_) async => null);

      // act
      final login = await iAuthRepository.login(email: userEmail, password: userPassword);

      // assert
      expect(login, isNull);
      verify(internetConnectionCheckerHelper.hasAccessToInternet()).called(1);
      verify(authLocalService.login(email: userEmail, password: userPassword)).called(1);
    });
  });
}
