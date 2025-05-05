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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? 'https://ui-avatars.com/api/?name=${json['name']}&background=random',
      role: json['role'] ?? 'User',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'role': role,
    };
  }
}
