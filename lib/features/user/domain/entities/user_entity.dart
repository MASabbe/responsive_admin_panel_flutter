class UserEntity {
  final String id;
  final String? name;
  final String? email;
  final String? avatarUrl;
  final String? role;

  UserEntity({
    required this.id,
    this.name,
    this.email,
    this.avatarUrl,
    this.role,
  });

  factory UserEntity.fromMap(String id, Map<String, dynamic> data) {
    return UserEntity(
      id: id,
      name: data['name'],
      email: data['email'],
      avatarUrl: data['avatarUrl'],
      role: data['role'],
    );
  }
}