import 'dart:convert';

import 'package:architectures/data/services/continent/continent_remote_service.dart';
import 'package:architectures/data/services/continent/continent_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import "package:http/testing.dart" as http_testing;

import '../../../../testing_data/temp_data/fake_continents.dart';

void main() {
  final String mainUrl = "";
  final Map<String, dynamic> success = {"success": true};
  final Map<String, dynamic> failure = {"success": false};
  final String internalServerError = "Internal Server Error";

  group('Continent Remote Service Test', () {
    //
    test('Test getContinents for success', () async {
      //
      final mockedClient = http_testing.MockClient(
        (_) async => http.Response(
          jsonEncode(fakeContinents.map((element) => element.toJson()).toList()),
          200,
        ),
      );

      final IContinentService continentService = ContinentRemoteService(
        mainUrl: mainUrl,
        client: mockedClient,
      );

      final continents = await continentService.getContinents();

      expect(continents, isNotEmpty);
      mockedClient.close();
    });

    //
    test('Test getContinents for failure', () async {
      //
      final mockedClient = http_testing.MockClient(
        (_) async => http.Response(internalServerError, 500),
      );

      final IContinentService continentService = ContinentRemoteService(
        mainUrl: mainUrl,
        client: mockedClient,
      );

      final continents = await continentService.getContinents();

      expect(continents, isEmpty);
      mockedClient.close();
    });
  });
}
