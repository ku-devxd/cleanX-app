// lib/core/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String name;
  final String email;
  final String role;
  final String accessToken;
  final String refreshToken;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    role: json['role'] ?? 'client',
    accessToken: json['access_token'] ?? '',
    refreshToken: json['refresh_token'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "role": role,
    "access_token": accessToken,
    "refresh_token": refreshToken,
  };
}

class AuthService {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  static const String baseUrl = "http://127.0.0.1:8000";

  UserModel? currentUser;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString('user_data');
    if (jsonData != null) {
      currentUser = UserModel.fromJson(jsonDecode(jsonData));
    }
  }

  Future<void> _save(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user.toJson()));
    currentUser = user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    currentUser = null;
  }

  Map<String, String> getAuthHeader() {
    if (currentUser == null) return {};
    return {"Authorization": "Bearer ${currentUser!.accessToken}"};
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');
    final body = {
      "name": name.trim(),
      "email": email.trim(),
      "password": password.trim(),
      "role": role.trim(),
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // /register currently returns tokens only; we may also want `/auth/me`
      final user = UserModel(
        name: name,
        email: email,
        role: role,
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
      );
      await _save(user);
      return user;
    } else {
      throw Exception(
        'Registration failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<UserModel> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final body = {"email": email, "password": password};
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // optionally call /auth/me to get name/role
      final access = data['access_token'];
      final refresh = data['refresh_token'];

      // try /auth/me
      String name = '';
      String role = 'client';
      try {
        final meRes = await http.get(
          Uri.parse('$baseUrl/auth/me'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $access",
          },
        );
        if (meRes.statusCode == 200) {
          final me = jsonDecode(meRes.body);
          name = me['name'] ?? '';
          role = me['role'] ?? role;
        }
      } catch (_) {}

      final user = UserModel(
        name: name,
        email: email,
        role: role,
        accessToken: access,
        refreshToken: refresh,
      );
      await _save(user);
      return user;
    } else {
      throw Exception('Login failed: ${response.statusCode} ${response.body}');
    }
  }

  Future<bool> refreshIfNeeded() async {
    if (currentUser == null) return false;
    final url = Uri.parse('$baseUrl/auth/refresh');
    final body = {"refresh_token": currentUser!.refreshToken};
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      currentUser = UserModel(
        name: currentUser!.name,
        email: currentUser!.email,
        role: currentUser!.role,
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
      );
      await _save(currentUser!);
      return true;
    }
    return false;
  }
}
