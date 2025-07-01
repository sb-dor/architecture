import 'dart:convert';

import 'package:architectures/data/services/auth/auth_service.dart';
import 'package:architectures/models/user.dart';
import 'package:http/http.dart' as http;

final class AuthRemoteService implements AuthService {
  AuthRemoteService({required this.mainUrl, http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String mainUrl;

  @override
  // TODO: implement isAuthenticated
  Future<bool> get isAuthenticated => throw UnimplementedError();

  @override
  Future<User?> login({required String email, required String password}) async {
    final request = await _client.post(
      Uri.parse('$mainUrl/login'),
      body: {"email": email, "password": password},
    );
    if (request.statusCode == 200) {
      return User.fromJson(jsonDecode(request.body));
    }
    return null;
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
