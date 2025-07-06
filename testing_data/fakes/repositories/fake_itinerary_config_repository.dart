import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/models/itinerary_config.dart';

class FakeItineraryConfigRepository implements IItineraryConfigRepository {
  @override
  Future<ItineraryConfig> getItineraryConfig() => Future.value(ItineraryConfig());

  @override
  Future<void> setItineraryConfig(ItineraryConfig itineraryConfig) => Future.value();
}
