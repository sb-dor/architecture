import 'activity.dart';
import 'destination.dart';

class Booking {
  Booking({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.destination,
    required this.activities,
  });

  final int? id;
  final DateTime startDate;
  final DateTime endDate;
  final Destination destination;
  final List<Activity> activities;
}
