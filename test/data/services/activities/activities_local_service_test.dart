import 'dart:convert';

import 'package:architectures/data/services/activities/activities_service.dart';
import 'package:architectures/models/activity.dart';
import 'package:architectures/utils/shared_preferences_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../testing_data/temp_data/fake_activities.dart';
import 'activities_local_service_test.mocks.dart';

@GenerateMocks([SharedPreferencesHelper])
void main() {
  final String ref = "DESTINATION";
  final List<Activity> activitiesTempArray = [kActivity];
  late final MockSharedPreferencesHelper sharedPreferencesHelper;

  setUpAll(() {
    sharedPreferencesHelper = MockSharedPreferencesHelper();
  });

  group('Activities Local Service Test', () {
    //
    test('Test local activities for empty array', () async {
      when(sharedPreferencesHelper.getString("activities")).thenAnswer((_) => jsonEncode(List.empty()));

      final IActivitiesService activitiesRepository = ActivitiesLocalService(
        sharedPreferencesHelper: sharedPreferencesHelper,
      );

      final activities = await activitiesRepository.getByDestination(ref);

      expect(activities, isEmpty);
    });

    //
    test('Test local activities for not empty array', () async {
      when(sharedPreferencesHelper.getString("activities")).thenAnswer(
        (_) => jsonEncode(activitiesTempArray.map((element) => element.toJson()).toList()),
      );

      final IActivitiesService activitiesRepository = ActivitiesLocalService(
        sharedPreferencesHelper: sharedPreferencesHelper,
      );

      final activities = await activitiesRepository.getByDestination(ref);

      expect(activities, isNotEmpty);
    });
  });
}
