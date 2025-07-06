class BookingSummary {
  BookingSummary({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.destinationRef,
    this.activitiesRef,
  });

  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String? destinationRef;
  final List<String>? activitiesRef;

  factory BookingSummary.fromJson(Map<String, dynamic> json) => BookingSummary(
    id: json['id'] as int,
    name: json['name'] as String,
    startDate: DateTime.parse(json['startDate'] as String),
    endDate: DateTime.parse(json['endDate'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
  };
}
