import 'dart:convert';
import 'dart:io';

import 'package:architectures/data/services/user_services/user_service.dart';
import 'package:architectures/models/user.dart';
import 'package:architectures/utils/constants.dart';
import 'package:http/http.dart' as http;

final class UserRemoteService implements IUserService {
  UserRemoteService({required this.mainUrl, http.Client? client})
    : _client = client ?? http.Client();

  final String mainUrl;
  final http.Client _client;

  @override
  Future<User?> user() async {
    final response = await _client.get(
      Uri.parse('/user'),
      headers: {HttpHeaders.authorizationHeader: "Bearer ${Constants.token}"},
    );
    if (response.statusCode != 200) return null;
    final Map<String, dynamic> json = jsonDecode(response.body);
    return User.fromJson(json);
  }
}
