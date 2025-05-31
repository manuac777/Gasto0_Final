import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gasto_0/Models/user.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'http://localhost:3000/api/auth/';
  static const String _userKey = 'user';
  static const String _tokenKey = 'token';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static Future<Map<String, dynamic>> registerUser(User user) async {
    try {
      final Map<String, dynamic> requestBody = user.toJson();

      final response = await http.post(
        Uri.parse('${_baseUrl}register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('ss');
        return {
          'success': true,
          'message': responseData['message'],
          //'user': User.fromJson(responseData['user']),
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'An error occurred',
        };
      }
    } catch (e) {
      print(e);
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> login(String correo, String password) async {
    try {
      final response = await http.post(Uri.parse('${_baseUrl}login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({'correo': correo, 'password': password}));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        final token = responseData['token'];
        final user = responseData['user'];

        await _secureStorage.write(key: _tokenKey, value: token);
        await _secureStorage.write(key: _userKey, value: json.encode(user));

        return {
          'success': true,
          'message': responseData,
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Ocurrio un error',
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: _tokenKey);
    return token != null;
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _userKey);
  }

  Future<User?> getUser() async {
    final userJson = await _secureStorage.read(key: _userKey);
    print(userJson);
    if (userJson != null) {
      final user = User.fromJson(json.decode(userJson));
      print(user.id);
      return user;
    }
    return null;
  }
}
