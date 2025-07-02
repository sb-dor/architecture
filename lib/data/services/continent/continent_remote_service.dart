import 'dart:convert';

import 'package:architectures/data/services/continent/continent_service.dart';
import 'package:architectures/models/continent.dart';
import 'package:http/http.dart' as http;

final class ContinentRemoteService implements IContinentService {
  ContinentRemoteService({required this.mainUrl, http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String mainUrl;

  @override
  Future<List<Continent>> getContinents() async {
    List<Continent> continents = [];
    final request = await _client.get(Uri.parse('$mainUrl/continent'));
    if (request.statusCode == 200) {
      final json = jsonDecode(request.body) as List<dynamic>;
      return continents = json.map((element) => Continent.fromJson(element)).toList();
    }
    return continents;
  }
}
