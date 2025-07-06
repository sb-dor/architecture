import 'package:architectures/data/repositories/continent/continent_repository.dart';
import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/models/continent.dart';
import 'package:architectures/models/itinerary_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SearchFormController extends ChangeNotifier {
  SearchFormController({
    required IContinentRepository continentRepository,
    required IItineraryConfigRepository itineraryConfigRepository,
    required Logger logger,
  }) : _continentRepository = continentRepository,
       _itineraryConfigRepository = itineraryConfigRepository,

       _logger = logger;

  final IContinentRepository _continentRepository;
  final IItineraryConfigRepository _itineraryConfigRepository;
  final Logger _logger;

  List<Continent> _continents = [];
  String? _selectedContinent;
  DateTimeRange? _dateRange;
  int _guests = 0;
  bool running = false;
  bool error = false;
  bool completed = false;

  /// True if the form is valid and can be submitted
  bool get valid => _guests > 0 && _selectedContinent != null && _dateRange != null;

  /// List of continents.
  /// Loaded in [load] command.
  List<Continent> get continents => _continents;

  /// Selected continent.
  /// Null means no continent is selected.
  String? get selectedContinent => _selectedContinent;

  /// Set selected continent.
  /// Set to null to clear the selection.
  set selectedContinent(String? continent) {
    _selectedContinent = continent;
    _logger.log(Level.debug, 'Selected continent: $continent');
    notifyListeners();
  }

  /// Date range.
  /// Null means no range is selected.
  DateTimeRange? get dateRange => _dateRange;

  /// Set date range.
  /// Can be set to null to clear selection.
  set dateRange(DateTimeRange? dateRange) {
    _dateRange = dateRange;
    _logger.log(Level.debug, 'Selected date range: $dateRange');
    notifyListeners();
  }

  /// Number of guests
  int get guests => _guests;

  /// Set number of guests
  /// If the quantity is negative, it will be set to 0
  set guests(int quantity) {
    if (quantity < 0) {
      _guests = 0;
    } else {
      _guests = quantity;
    }
    _logger.log(Level.debug, 'Set guests number: $_guests');
    notifyListeners();
  }

  /// Load the list of continents and current itinerary config.

  Future<void> load() async {
    try {
      running = true;
      error = false;
      completed = false;
      notifyListeners();
      await _loadContinents();
      completed = true;
    } catch (error, stackTrace) {
      await loadItineraryConfig();
      this.error = true;
      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      running = false;
      notifyListeners();
    }
  }

  Future<void> _loadContinents() async {
    _continents = await _continentRepository.getContinents();

    _logger.log(Level.debug, 'Continents (${_continents.length}) loaded');

    notifyListeners();
  }

  Future<void> loadItineraryConfig() async {
    final itineraryConfig = await _itineraryConfigRepository.getItineraryConfig();

    _selectedContinent = itineraryConfig.continent;
    if (itineraryConfig.startDate != null && itineraryConfig.endDate != null) {
      _dateRange = DateTimeRange(start: itineraryConfig.startDate!, end: itineraryConfig.endDate!);
    }
    _guests = itineraryConfig.guests ?? 0;
    _logger.log(Level.debug, 'ItineraryConfig loaded');
    notifyListeners();
  }

  Future<void> updateItineraryConfig({required VoidCallback onSave}) async {
    assert(valid, "called when valid was false");
    final result = await _itineraryConfigRepository.setItineraryConfig(
      ItineraryConfig(
        continent: _selectedContinent,
        startDate: _dateRange!.start,
        endDate: _dateRange!.end,
        guests: _guests,
      ),
    );
    onSave();
  }
}
