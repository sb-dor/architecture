class Destination {
  Destination({
    required this.ref,
    required this.country,
    required this.continent,
    required this.knownFor,
    required this.tags,
    required this.imageURL,
  });

  final String ref;
  final String country;
  final String continent;
  final String knownFor;
  final List<String> tags;
  final String imageURL;

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
    ref: json['ref'] as String,
    country: json['country'] as String,
    continent: json['continent'] as String,
    knownFor: json['knownFor'] as String,
    tags: List<String>.from(json['tags']),
    imageURL: json['imageURL'] as String,
  );

  Map<String, dynamic> toJson() => {
    'ref': ref,
    'country': country,
    'continent': continent,
    'knownFor': knownFor,
    'tags': tags,
    'imageURL': imageURL,
  };
}
