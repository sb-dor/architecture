import 'package:architectures/data/repositories/activities/activities_repository.dart';
import 'package:architectures/models/activity.dart';

import '../../temp_data/fake_activities.dart';
import '../../temp_data/fake_destination.dart';

class FakeActiveRepositoryImpl implements IActivitiesRepository {
  final Map<String, List<Activity>> _activities = {
    "DESTINATION": [kActivity],
    kDestination1.ref: [kActivity],
  };

  @override
  Future<List<Activity>> getByDestination(String ref) async {
    return _activities[ref] ?? <Activity>[];
  }
}
