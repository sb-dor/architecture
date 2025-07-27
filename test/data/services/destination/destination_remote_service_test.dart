import 'dart:convert';

import 'package:architectures/data/services/destination/destination_service.dart';
import 'package:architectures/models/destination.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart' as http_testing;
import 'package:http/http.dart' as http;

import '../../../../testing_data/temp_data/fake_destination.dart';

void main() {
  final destinations = <Destination>[kDestination1, kDestination2];
  final mainUrl = "";
  final serverError = "Internal Server Error";

  group('Destination Remote test', () {
    //
    test('getDestinations test for success', () async {
      //
      final mockedClient = http_testing.MockClient(
        (_) async => http.Response(jsonEncode(destinations), 200),
      );

      final destinationService = DestinationRemoteService(mainUrl: mainUrl, client: mockedClient);

      final getDestinations = await destinationService.getDestinations();

      expect(getDestinations, isNotEmpty);
      mockedClient.close();
    });

    test('getDestinations test for failure', () async {
      //
      final mockedClient = http_testing.MockClient(
        (_) async => http.Response(jsonEncode(serverError), 500),
      );

      final destinationService = DestinationRemoteService(mainUrl: mainUrl, client: mockedClient);

      final getDestinations = await destinationService.getDestinations();

      expect(getDestinations, isEmpty);
      mockedClient.close();
    });
  });
}
