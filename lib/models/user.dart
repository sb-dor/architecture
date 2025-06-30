class User {
  User({required this.name, required this.picture});

  final String name;
  final String picture;

  factory User.fromJson(Map<String, dynamic> json) =>
      User(name: json['name'] as String, picture: json['picture'] as String);

  Map<String, dynamic> toJson() => {'name': name, 'picture': picture};
}
