class ItineraryConfig {
  ItineraryConfig({
    this.continent,
    this.startDate,
    this.endDate,
    this.guests,
    this.destination,
    this.activities = const <String>[],
  });

  final String? continent;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? guests;
  final String? destination;
  final List<String> activities;

  factory ItineraryConfig.fromJson(Map<String, dynamic> json) {
    return ItineraryConfig(
      continent: json['continent'] as String?,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      guests: json['guests'] as int?,
      destination: json['destination'] as String?,
      activities: (json['activities'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'continent': continent,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'guests': guests,
      'destination': destination,
      'activities': activities,
    };
  }

  ItineraryConfig copyWith({
    final String? continent,
    final DateTime? startDate,
    final DateTime? endDate,
    final int? guests,
    final String? destination,
    final List<String>? activities,
  }) {
    return ItineraryConfig(
      continent: continent ?? this.continent,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      guests: guests ?? this.guests,
      destination: destination ?? this.destination,
      activities: activities ?? this.activities,
    );
  }
}
