import 'dart:convert';

import 'package:architectures/models/itinerary_config.dart';
import 'package:architectures/utils/constants.dart';
import 'package:architectures/utils/shared_preferences_helper.dart';
import 'package:logger/logger.dart';

abstract interface class IItineraryConfigService {
  Future<ItineraryConfig> getItineraryConfig();

  Future<void> setItineraryConfig(ItineraryConfig itineraryConfig);
}

final class ItineraryConfigServiceImpl implements IItineraryConfigService {
  ItineraryConfigServiceImpl({
    required SharedPreferencesHelper sharedPreferencesHelper,
    required Logger logger,
  }) : _sharedPreferencesHelper = sharedPreferencesHelper,
       _logger = logger;

  final SharedPreferencesHelper _sharedPreferencesHelper;
  final Logger _logger;

  @override
  Future<ItineraryConfig> getItineraryConfig() async {
    final String? itineraryConfigValueString = _sharedPreferencesHelper.getString(
      Constants.itineraryConfigKey,
    );
    if (itineraryConfigValueString != null) {
      final Map<String, dynamic> itineraryConfigValue = jsonDecode(itineraryConfigValueString);
      return ItineraryConfig.fromJson(itineraryConfigValue);
    }
    return ItineraryConfig();
  }

  @override
  Future<void> setItineraryConfig(ItineraryConfig itineraryConfig) => _sharedPreferencesHelper
      .saveString(Constants.itineraryConfigKey, jsonEncode(itineraryConfig.toJson()));
}
