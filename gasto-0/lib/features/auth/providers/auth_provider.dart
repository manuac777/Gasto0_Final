import 'package:flutter/material.dart';
import 'package:gasto_0/Models/user.dart';
import 'package:gasto_0/core/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final response = await _authService.login(email, password);

    _isLoading = false;
    _errorMessage = response['success'] ? null : response['message'];
    notifyListeners();

    return response['success'];
  }

  Future<bool> isAuthenticated() async {
    return await _authService.isAuthenticated();
  }

  Future<User?> getUser() async {
    final user = await _authService.getUser();
    return user;
  }

  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }

  Future<String?> getToken() async {
    return await _authService.getToken();
  }
}
