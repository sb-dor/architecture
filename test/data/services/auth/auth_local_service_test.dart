import 'dart:convert';

import 'package:architectures/data/services/auth/auth_local_service.dart';
import 'package:architectures/utils/shared_preferences_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../testing_data/temp_data/fake_user.dart';
import 'auth_local_service_test.mocks.dart';

@GenerateMocks([SharedPreferencesHelper])
void main() {
  const String email = "";
  const String password = "";
  late final MockSharedPreferencesHelper sharedPreferencesHelper;
  late final AuthLocalService authLocalService;

  setUpAll(() {
    sharedPreferencesHelper = MockSharedPreferencesHelper();
    authLocalService = AuthLocalService(sharedPreferencesHelper: sharedPreferencesHelper);
  });

  group('Auth local service test', () {
    //
    test('Test isAuthenticated method for success', () async {
      when(
        sharedPreferencesHelper.getString(any),
      ).thenAnswer((async) => jsonEncode(kUser.toJson()));

      final result = await authLocalService.isAuthenticated;

      expect(result, true);
    });

    //
    test('Test isAuthenticated method for fail', () async {
      when(sharedPreferencesHelper.getString(any)).thenAnswer((async) => null);

      final result = await authLocalService.isAuthenticated;

      expect(result, false);
    });

    //
    test('Test login method for success - with already logged user', () async {
      when(
        sharedPreferencesHelper.getString(any),
      ).thenAnswer((async) => jsonEncode(kUser.toJson()));

      final user = await authLocalService.login(email: email, password: password);

      expect(user, isNotNull);
    });

    //
    test('Test login method for success - with new user', () async {
      when(sharedPreferencesHelper.getString(any)).thenAnswer((async) => null);
      when(
        sharedPreferencesHelper.saveString(any, any),
      ).thenAnswer((async) => Future<void>.value());

      final user = await authLocalService.login(email: email, password: password);

      expect(user, isNotNull);
    });

    //
    test('Test logout method for success - with already logged user', () async {
      when(
        sharedPreferencesHelper.getString(any),
      ).thenAnswer((async) => jsonEncode(kUser.toJson()));

      final logout = await authLocalService.logout();

      expect(logout, true);
    });

    test('Test logout method for success - if there is no user', () async {
      when(sharedPreferencesHelper.getString(any)).thenAnswer((async) => null);

      final logout = await authLocalService.logout();

      expect(logout, true);
    });
  });
}
