import 'package:architectures/data/repositories/user_repository/user_repository.dart';
import 'package:architectures/data/services/user_services/user_service.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../testing_data/temp_data/fake_user.dart';
import 'user_repository_test.mocks.dart';

@GenerateMocks([IUserService, InternetConnectionCheckerHelper])
void main() {
  late final MockIUserService mockIUserRemoteService;
  late final MockIUserService mockIUserLocalService;
  late final MockInternetConnectionCheckerHelper mockInternetConnectionCheckerHelper;

  late final IUserRepository userRepository;

  setUpAll(() {
    mockIUserRemoteService = MockIUserService();
    mockIUserLocalService = MockIUserService();
    mockInternetConnectionCheckerHelper = MockInternetConnectionCheckerHelper();

    userRepository = UserRepositoryImpl(
      userRemoteService: mockIUserRemoteService,
      userLocalService: mockIUserLocalService,
      internetConnectionCheckerHelper: mockInternetConnectionCheckerHelper,
    );
  });

  group("Remote Test", () {
    //
    test('Check user for existing', () async {
      // arrange
      when(mockInternetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);
      when(mockIUserRemoteService.user()).thenAnswer((_) async => kUser);
      // act

      final user = await userRepository.user();

      // assert
      expect(user, isNotNull);
      verify(mockIUserRemoteService.user()).called(1);
    });

    //
    test('Check user for non-existing', () async {
      // arrange
      when(mockInternetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);
      when(mockIUserRemoteService.user()).thenAnswer((_) async => null);
      // act

      final user = await userRepository.user();

      // assert
      expect(user, isNull);
      verify(mockIUserRemoteService.user()).called(1);
    });
  });


  group("Local Test", () {
    //
    test('Check user for existing', () async {
      // arrange
      when(mockInternetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => false);
      when(mockIUserLocalService.user()).thenAnswer((_) async => kUser);
      // act

      final user = await userRepository.user();

      // assert
      expect(user, isNotNull);
      verify(mockIUserLocalService.user()).called(1);
    });

    //
    test('Check user for non-existing', () async {
      // arrange
      when(mockInternetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => false);
      when(mockIUserLocalService.user()).thenAnswer((_) async => null);
      // act

      final user = await userRepository.user();

      // assert
      expect(user, isNull);
      verify(mockIUserLocalService.user()).called(1);
    });
  });
}
