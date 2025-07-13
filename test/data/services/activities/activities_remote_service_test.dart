import 'dart:convert';

import 'package:architectures/data/services/activities/activities_service.dart';
import 'package:architectures/models/activity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart' as http_testing;
import 'package:http/http.dart' as http;

import '../../../../testing_data/temp_data/fake_activities.dart';

void main() {
  final String mainUrl = "";
  final String ref = "";
  final List<Activity> activitiesTempList = [kActivity];

  group('Activities Remote Service Test', () {
    //
    test('Test remote activities for empty array', () async {
      //
      final mockedClient = http_testing.MockClient(
        (_) async => http.Response(jsonEncode(List.empty()), 200),
      );

      final IActivitiesService activitiesService = ActivitiesRemoteService(
        mainUrl: mainUrl,
        client: mockedClient,
      );

      final activities = await activitiesService.getByDestination(ref);

      expect(activities, isEmpty);
    });

    test('Test remote activities for not empty array', () async {
      //
      final mockedClient = http_testing.MockClient(
        (_) async => http.Response(
          jsonEncode(activitiesTempList.map((element) => element.toJson()).toList()),
          200,
        ),
      );

      final IActivitiesService activitiesService = ActivitiesRemoteService(
        mainUrl: mainUrl,
        client: mockedClient,
      );

      final activities = await activitiesService.getByDestination(ref);

      expect(activities, isNotEmpty);
    });
  });
}
