import 'package:architectures/models/itinerary_config.dart';

import '../fakes/repositories/fake_itinerary_config_repository.dart';
import 'fake_activities.dart';

final fakeItineraryConfig = ItineraryConfig(
  continent: 'Europe',
  startDate: DateTime(2024, 01, 01),
  endDate: DateTime(2024, 01, 31),
  guests: 2,
  destination: 'DESTINATION',
  activities: [kActivity.ref]
);
