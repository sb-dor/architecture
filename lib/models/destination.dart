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
}
