import 'activity.dart';
import 'destination.dart';

class Booking {
  Booking({
    this.id,
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

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'] as int?,
    startDate: DateTime.parse(json['startDate'] as String),
    endDate: DateTime.parse(json['endDate'] as String),
    destination: Destination.fromJson(json['destination']),
    activities: (json['activities'] as List).map((e) => Activity.fromJson(e)).toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'name': "Booking",
    'destinationRef': destination.ref, // вместо destination.toJson()
    'activitiesRef': activities.map((e) => e.ref).toList(), // вместо .toJson()
  };
}
