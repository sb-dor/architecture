class Continent {
  Continent({required this.name, required this.imageUrl});

  final String name;
  final String imageUrl;

  factory Continent.fromJson(Map<String, dynamic> json) {
    return Continent(name: json['name'] as String, imageUrl: json['imageUrl'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'imageUrl': imageUrl};
  }
}
