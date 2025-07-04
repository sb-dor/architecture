import 'package:architectures/data/services/itinerary_config_service/itinerary_config_service.dart';
import 'package:architectures/models/itinerary_config.dart';

abstract interface class IItineraryConfigRepository {
  Future<ItineraryConfig> getItineraryConfig();

  Future<void> setItineraryConfig(ItineraryConfig itineraryConfig);
}

final class ItineraryConfigRepositoryImpl implements IItineraryConfigRepository {
  ItineraryConfigRepositoryImpl({required IItineraryConfigService iItineraryConfigService})
    : _iItineraryConfigService = iItineraryConfigService;

  final IItineraryConfigService _iItineraryConfigService;

  @override
  Future<ItineraryConfig> getItineraryConfig() => _iItineraryConfigService.getItineraryConfig();

  @override
  Future<void> setItineraryConfig(ItineraryConfig itineraryConfig) =>
      _iItineraryConfigService.setItineraryConfig(itineraryConfig);
}
