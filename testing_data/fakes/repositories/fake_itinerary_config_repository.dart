import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/models/itinerary_config.dart';

class FakeItineraryConfigRepository implements IItineraryConfigRepository {

  FakeItineraryConfigRepository(this.itineraryConfig);

  final ItineraryConfig itineraryConfig;

  @override
  Future<ItineraryConfig> getItineraryConfig() => Future.value(itineraryConfig);

  @override
  Future<void> setItineraryConfig(ItineraryConfig itineraryConfig) => Future.value();
}
