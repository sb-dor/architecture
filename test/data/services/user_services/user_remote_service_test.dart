import 'dart:convert';

import 'package:architectures/data/services/user_services/user_remote_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart' as http_testing;
import 'package:http/http.dart' as http;
import '../../../../testing_data/temp_data/fake_user.dart';

void main() {
  final String mainUrl = "";

  group('User remote service test', () {
    //
    test('test user function for success', () async {
      //
      final mockedClient = http_testing.MockClient(
        (_) async => http.Response(jsonEncode(kUser.toJson()), 200),
      );

      final userRemoteService = UserRemoteService(mainUrl: mainUrl, client: mockedClient);

      final user = await userRemoteService.user();
      expect(user, isNotNull);
      mockedClient.close();
    });

    //
    test('test user function for failure', () async {
      //
      final mockedClient = http_testing.MockClient(
        (_) async => http.Response(jsonEncode("Internal server error"), 500),
      );

      final userRemoteService = UserRemoteService(mainUrl: mainUrl, client: mockedClient);

      final user = await userRemoteService.user();
      expect(user, isNull);
      mockedClient.close();
    });
  });
}
