import 'package:architectures/models/activity.dart';
import 'package:architectures/models/destination.dart';

class BookingSummary {
  BookingSummary({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
}
