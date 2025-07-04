import 'package:architectures/models/itinerary_config.dart';

abstract interface class IItineraryConfigService {
  Future<ItineraryConfig> getItineraryConfig();

  Future<void> setItineraryConfig(ItineraryConfig itineraryConfig);
}

final class ItineraryConfigServiceImpl implements IItineraryConfigService {
  @override
  Future<ItineraryConfig> getItineraryConfig() async {
    return ItineraryConfig();
  }

  @override
  Future<void> setItineraryConfig(ItineraryConfig itineraryConfig) async {
  }
}
