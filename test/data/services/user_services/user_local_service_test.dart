import 'dart:convert';

import 'package:architectures/data/services/user_services/user_local_service.dart';
import 'package:architectures/utils/shared_preferences_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../testing_data/temp_data/fake_user.dart';
import 'user_local_service_test.mocks.dart';

@GenerateMocks([SharedPreferencesHelper])
void main() {
  late final MockSharedPreferencesHelper sharedPreferencesHelper;
  late final UserLocalService userLocalService;

  setUpAll(() {
    //
    sharedPreferencesHelper = MockSharedPreferencesHelper();
    userLocalService = UserLocalService(sharedPreferencesHelper: sharedPreferencesHelper);
  });

  group('test user local service', () {
    //
    test('test user function for success', () async {
      //
      when(sharedPreferencesHelper.getString(any)).thenReturn(jsonEncode(kUser.toJson()));

      final user = await userLocalService.user();

      expect(user, isNotNull);
    });

    //
    test('test user function for null', () async {
      //
      when(sharedPreferencesHelper.getString(any)).thenReturn(null);

      final user = await userLocalService.user();

      expect(user, isNull);
    });

    //
    test('test user function for failure', () async {
      //
      when(sharedPreferencesHelper.getString(any)).thenThrow(Exception());

      final user = userLocalService.user();

      expect(user, throwsException);
    });
  });
}
