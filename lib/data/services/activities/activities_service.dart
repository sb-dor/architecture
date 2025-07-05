import 'dart:convert';
import 'dart:io';

import 'package:architectures/models/activity.dart';
import 'package:architectures/utils/constants.dart';
import "package:http/http.dart" as http;

abstract interface class IActivitiesService {
  Future<List<Activity>> getByDestination(String ref);
}

final class ActivitiesLocalService implements IActivitiesService {
  @override
  Future<List<Activity>> getByDestination(String ref) {
    // TODO: implement getByDestination
    throw UnimplementedError();
  }
}

final class ActivitiesRemoteService implements IActivitiesService {
  ActivitiesRemoteService({required String mainUrl, http.Client? client})
    : _mainUrl = mainUrl,
      _client = client ?? http.Client();

  final String _mainUrl;
  final http.Client _client;

  @override
  Future<List<Activity>> getByDestination(String ref) async {
    List<Activity> activities = [];
    final request = await _client.get(
      Uri.parse("$_mainUrl/destination/$ref/activity"),
      headers: {HttpHeaders.authorizationHeader: "Bearer ${Constants.token}"},
    );
    if (request.statusCode == 200) {
      final json = jsonDecode(request.body) as List<dynamic>;
      activities = json.map((element) => Activity.fromJson(element)).toList();
    }
    return activities;
  }
}
