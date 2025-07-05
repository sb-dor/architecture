enum TimeOfDay {
  any,
  morning,
  afternoon,
  evening,
  night;

  static TimeOfDay fromString(String val) => switch (val) {
    "morning" => TimeOfDay.any,
    "afternoon" => TimeOfDay.afternoon,
    "evening" => TimeOfDay.evening,
    "night" => TimeOfDay.night,
    _ => TimeOfDay.any,
  };
}

enum ActivityTimeOfDay { daytime, evening }

class Activity {
  const Activity({
    required this.name,
    required this.description,
    required this.locationName,
    required this.duration,
    required this.timeOfDay,
    required this.familyFriendly,
    required this.price,
    required this.destinationRef,
    required this.ref,
    required this.imageUrl,
  });

  final String name;
  final String description;
  final String locationName;
  final int duration;
  final TimeOfDay timeOfDay;
  final bool familyFriendly;
  final int price;
  final String destinationRef;
  final String ref;
  final String imageUrl;

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      name: json['name'] as String,
      description: json['description'] as String,
      locationName: json['locationName'] as String,
      duration: json['duration'] as int,
      timeOfDay: TimeOfDay.fromString(json['timeOfDay']),
      familyFriendly: json['familyFriendly'] as bool,
      price: json['price'] as int,
      destinationRef: json['destinationRef'] as String,
      ref: json['ref'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'locationName': locationName,
    'duration': duration,
    'time_of_day': timeOfDay.name,
    'family_friendly': familyFriendly,
    'price': price,
    'destination_ref': destinationRef,
    'ref': ref,
    'imageUrl': imageUrl,
  };
}
