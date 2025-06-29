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
  final String timeOfDay;
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
      timeOfDay: json['timeOfDay'] as String,
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
    'timeOfDay': timeOfDay,
    'familyFriendly': familyFriendly,
    'price': price,
    'destinationRef': destinationRef,
    'ref': ref,
    'imageUrl': imageUrl,
  };
}
