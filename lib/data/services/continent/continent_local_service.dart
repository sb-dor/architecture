import 'dart:convert';

import 'package:architectures/data/services/continent/continent_service.dart';
import 'package:architectures/models/continent.dart';
import 'package:architectures/utils/shared_preferences_helper.dart';

final class ContinentLocalService implements IContinentService {
  ContinentLocalService({required SharedPreferencesHelper sharedPreferencesHelper})
    : _sharedPreferencesHelper = sharedPreferencesHelper;

  final SharedPreferencesHelper _sharedPreferencesHelper;

  @override
  Future<List<Continent>> getContinents() async {
    final getContinents = _sharedPreferencesHelper.getString('continents') ?? '';
    if (getContinents.isEmpty) return <Continent>[];
    final Map<String, dynamic> decodedContinents = jsonDecode(getContinents);
    final List<dynamic> continents = decodedContinents['continents'];
    return continents.map((e) => Continent.fromJson(e)).toList();
  }
}
