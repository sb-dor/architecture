import 'dart:convert';
import 'dart:io';

import 'package:architectures/models/destination.dart';
import 'package:architectures/utils/constants.dart';
import 'package:architectures/utils/shared_preferences_helper.dart';
import 'package:flutter/cupertino.dart';
import "package:http/http.dart" as http;

abstract interface class IDestinationService {
  Future<List<Destination>> getDestinations();
}

final class DestinationRemoteService implements IDestinationService {
  DestinationRemoteService({required String mainUrl, http.Client? client})
    : _mainUrl = mainUrl,
      _client = client ?? http.Client();

  final String _mainUrl;
  final http.Client _client;

  @override
  Future<List<Destination>> getDestinations() async {
    List<Destination> destinations = [];
    final request = await _client.get(
      Uri.parse('$_mainUrl/destination'),
      headers: {HttpHeaders.authorizationHeader: "Bearer ${Constants.token}"},
    );
    debugPrint("requst from des: ${request.body}");
    if (request.statusCode == 200) {
      final json = jsonDecode(request.body) as List<dynamic>;
      destinations = json.map((element) => Destination.fromJson(element)).toList();
    }
    return destinations;
  }
}

class DestinationLocalService implements IDestinationService {
  DestinationLocalService({required SharedPreferencesHelper sharedPreferencesHelper})
    : _sharedPreferencesHelper = sharedPreferencesHelper;

  final SharedPreferencesHelper _sharedPreferencesHelper;

  @override
  Future<List<Destination>> getDestinations() async {
    final getContinents = _sharedPreferencesHelper.getString('destinations') ?? '';
    if (getContinents.isEmpty) return <Destination>[];
    final Map<String, dynamic> decodedContinents = jsonDecode(getContinents);
    final List<dynamic> continents = decodedContinents['continents'];
    return continents.map((e) => Destination.fromJson(e)).toList();
  }
}
