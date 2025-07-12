import 'dart:convert';

import 'package:architectures/data/services/auth/auth_remote_service.dart';
import 'package:architectures/data/services/auth/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart' as http_test;
import 'package:http/http.dart' as http;

void main() {
  final userJson = <String, dynamic>{"name": "User", "picture": "temp"};
  final failedResult = <String, dynamic>{"success": false};
  final successResult = <String, dynamic>{"success": true};
  const String mainUrl = "";
  const String email = "";
  const String password = "";

  group('Auth Service Test', () {
    //
    test('Authentication Test', () async {
      //
      final mockedClient = http_test.MockClient(
        (_) async => http.Response(jsonEncode(userJson), 200),
      );

      final IAuthService authService = AuthRemoteService(mainUrl: mainUrl, client: mockedClient);

      final user = await authService.isAuthenticated;

      expect(user, true);
      mockedClient.close();
    });

    //
    test('Login test with successful result', () async {
      //
      final mockedClient = http_test.MockClient(
        (_) async => http.Response(jsonEncode(userJson), 200),
      );

      final IAuthService authService = AuthRemoteService(mainUrl: mainUrl, client: mockedClient);

      final login = await authService.login(email: email, password: password);

      expect(login, isNotNull);
      mockedClient.close();
    });

    //
    test('Login test with failed result', () async {
      //
      final mockedClient = http_test.MockClient(
        (_) async => http.Response(jsonEncode(failedResult), 401),
      );

      final IAuthService authService = AuthRemoteService(mainUrl: mainUrl, client: mockedClient);

      final login = await authService.login(email: email, password: password);

      expect(login, isNull);
      mockedClient.close();
    });

    //
    test('Logout test with successful result', () async {
      //
      final mockedClient = http_test.MockClient(
        (_) async => http.Response(jsonEncode(successResult), 200),
      );

      final IAuthService authService = AuthRemoteService(mainUrl: mainUrl, client: mockedClient);

      final logout = await authService.logout();

      expect(logout, isTrue);
      mockedClient.close();
    });

    //
    test('Logout test with failed result', () async {
      //
      final mockedClient = http_test.MockClient(
        (_) async => http.Response(jsonEncode(successResult), 200),
      );

      final IAuthService authService = AuthRemoteService(mainUrl: mainUrl, client: mockedClient);

      final logout = await authService.logout();

      expect(logout, isTrue);
      mockedClient.close();
    });
  });
}
