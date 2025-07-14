import 'package:architectures/models/booking.dart';
import 'package:architectures/models/booking_summary.dart';

import 'fake_activities.dart';
import 'fake_destination.dart';

final kBooking = Booking(
  id: 1,
  startDate: DateTime(2024, 01, 01),
  endDate: DateTime(2024, 02, 12),
  destination: kDestination1,
  activities: [kActivity],
);

final kBookingSummary = BookingSummary(
  id: 0,
  startDate: kBooking.startDate,
  endDate: kBooking.endDate,
  name: '${kDestination1.name}, ${kDestination1.continent}',
);

final kBookingApiModel = BookingSummary(
  id: 0,
  startDate: kBooking.startDate,
  endDate: kBooking.endDate,
  name: '${kDestination1.name}, ${kDestination1.continent}',
  destinationRef: kDestination1.ref,
  activitiesRef: [kActivity.ref],
);
