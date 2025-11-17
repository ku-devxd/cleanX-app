class UserModel {
  final String name;
  final String email;
  final String role;
  final String token;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    role: json['role'] ?? 'client',
    token: json['access_token'] ?? json['token'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "role": role,
    "token": token,
  };
}
