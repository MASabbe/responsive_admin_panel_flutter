import 'package:responsive_admin_panel_flutter/core/utils/save_convert.dart';

class Team {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  Team({
    this.id = 0,
    this.email = "",
    this.firstName = "",
    this.lastName = "",
    this.avatar = "",
  });

  factory Team.fromJson(Map<String, dynamic>? json) => Team(
    id: asInt(json, 'id'),
    email: asString(json, 'email'),
    firstName: asString(json, 'first_name'),
    lastName: asString(json, 'last_name'),
    avatar: asString(json, 'avatar'),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'first_name': firstName,
    'last_name': lastName,
    'avatar': avatar,
  };
}

