class User {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        avatarUrl: json['avatarUrl'] ?? '',
        role: json['role'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
        'role': role,
      };
}
