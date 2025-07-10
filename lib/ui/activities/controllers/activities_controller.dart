import 'package:architectures/data/repositories/activities/activities_repository.dart';
import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/models/activity.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ActivitiesController extends ChangeNotifier {
  ActivitiesController({
    required IActivitiesRepository activityRepository,
    required IItineraryConfigRepository itineraryConfigRepository,
    required Logger logger,
  }) : _activityRepository = activityRepository,
       _itineraryConfigRepository = itineraryConfigRepository,
       _logger = logger;

  final IActivitiesRepository _activityRepository;
  final IItineraryConfigRepository _itineraryConfigRepository;
  final Logger _logger;

  List<Activity> _daytimeActivities = <Activity>[];
  List<Activity> _eveningActivities = <Activity>[];
  final Set<String> _selectedActivities = <String>{};

  /// List of daytime [Activity] per destination.
  List<Activity> get daytimeActivities => _daytimeActivities;

  /// List of evening [Activity] per destination.
  List<Activity> get eveningActivities => _eveningActivities;

  /// Selected [Activity] by ref.
  Set<String> get selectedActivities => _selectedActivities;

  /// Load list of [Activity] for a [Destination] by ref.
  ///
  ///
  bool loading = false;
  bool completed = false;
  bool completedSave = false;

  Future<void> loadActivities() async {
    if (loading) return;
    completed = false;
    loading = true;
    notifyListeners();

    final result = await _itineraryConfigRepository.getItineraryConfig();

    final destinationRef = result.destination;
    if (destinationRef == null) {
      _logger.log(Level.debug, 'Destination missing in ItineraryConfig');
      return;
    }

    _selectedActivities.addAll(result.activities);

    final resultActivities = await _activityRepository.getByDestination(
      destinationRef,
    );

    if (resultActivities.isNotEmpty) {
      _daytimeActivities =
          resultActivities
              .where(
                (activity) => [
                  TimeOfDay.any,
                  TimeOfDay.morning,
                  TimeOfDay.afternoon,
                ].contains(activity.timeOfDay),
              )
              .toList();

      _eveningActivities =
          resultActivities
              .where(
                (activity) => [
                  TimeOfDay.evening,
                  TimeOfDay.night,
                ].contains(activity.timeOfDay),
              )
              .toList();

      _logger.log(
        Level.debug,
        'Activities (daytime: ${_daytimeActivities.length}, '
        'evening: ${_eveningActivities.length}) loaded',
      );
    }

    loading = false;
    completed = true;

    notifyListeners();
  }

  /// Add [Activity] to selected list.
  void addActivity(String activityRef) {
    assert(
      (_daytimeActivities + _eveningActivities).any(
        (activity) => activity.ref == activityRef,
      ),
      "Activity $activityRef not found",
    );
    _selectedActivities.add(activityRef);
    _logger.log(Level.debug, 'Activity $activityRef added');
    notifyListeners();
  }

  /// Remove [Activity] from selected list.
  void removeActivity(String activityRef) {
    assert(
      (_daytimeActivities + _eveningActivities).any(
        (activity) => activity.ref == activityRef,
      ),
      "Activity $activityRef not found",
    );
    _selectedActivities.remove(activityRef);
    _logger.log(Level.debug, 'Activity $activityRef removed');
    notifyListeners();
  }

  Future<void> saveActivities() async {
    final resultConfig = await _itineraryConfigRepository.getItineraryConfig();

    final result = await _itineraryConfigRepository.setItineraryConfig(
      resultConfig.copyWith(activities: _selectedActivities.toList()),
    );
  }
}
