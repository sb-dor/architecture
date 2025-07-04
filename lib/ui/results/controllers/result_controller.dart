import 'package:architectures/data/repositories/destination/destination_repository.dart';
import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/models/destination.dart';
import 'package:architectures/models/itinerary_config.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ResultController extends ChangeNotifier {
  ResultController({
    required IDestinationRepository destinationRepository,
    required IItineraryConfigRepository itineraryConfigRepository,
    required Logger logger,
  }) : _destinationRepository = destinationRepository,
       _itineraryConfigRepository = itineraryConfigRepository,
       _logger = logger;

  final IDestinationRepository _destinationRepository;

  final IItineraryConfigRepository _itineraryConfigRepository;

  final Logger _logger;

  List<Destination> _destinations = [];

  List<Destination> get destinations => _destinations;

  ItineraryConfig? _itineraryConfig;

  ItineraryConfig get config => _itineraryConfig ?? ItineraryConfig();

  bool searching = false;

  bool completed = false;

  Future<void> getDestinations() async {
    final result = await _destinationRepository.getDestinations();
    _destinations =
        result
            .where((destination) => destination.continent == _itineraryConfig!.continent)
            .toList();
    _logger.log(Level.debug, 'Destinations (${_destinations.length}) loaded');
    notifyListeners();
  }

  Future<void> search() async {
    if (searching) return;
    searching = true;
    completed = false;
    notifyListeners();
    // Load current itinerary config
    _itineraryConfig = await _itineraryConfigRepository.getItineraryConfig();
    _logger.log(Level.debug, 'Failed to load stored ItineraryConfig');
    notifyListeners();

    searching = false;
    completed = true;
    // After finish loading results, notify the view
    notifyListeners();
  }

  Future<void> updateItineraryConfig(String destinationRef) async {
    assert(destinationRef.isNotEmpty, "destinationRef should not be empty");

    final resultConfig = await _itineraryConfigRepository.getItineraryConfig();
    _logger.log(Level.debug, 'Failed to load stored ItineraryConfig');

    final itineraryConfig = resultConfig;
    final result = await _itineraryConfigRepository.setItineraryConfig(
      itineraryConfig.copyWith(destination: destinationRef, activities: []),
    );
  }
}
