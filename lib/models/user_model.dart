import 'dart:convert';

class UserModel {
  final String email;
  final String name;
  final String profilePci;
  final String token;
  final String uid;
  UserModel(
      {required this.email,
      required this.name,
      required this.profilePci,
      required this.uid,
      required this.token});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'profilePci': profilePci,
      'token': token,
      'uid': uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePci: map['profilePci'] ?? '',
      token: map['token'] ?? '',
      uid: map['_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? email,
    String? name,
    String? profilePci,
    String? token,
    String? uid,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePci: profilePci ?? this.profilePci,
      token: token ?? this.token,
      uid: uid ?? this.uid,
    );
  }
}
