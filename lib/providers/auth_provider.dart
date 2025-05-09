import 'package:flutter/material.dart';
import 'package:flutter_school_app/services/schedule_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_school_app/services/auth_service.dart'; // Asegúrate de importar el servicio

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;


  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    notifyListeners();
  }

  // Método para hacer login usando AuthService
  Future<void> login(String email, String password) async {
    try {
      final user = await _authService.login(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      _isAuthenticated = true;
      await ScheduleService().fetchHorario();

      print("Usuario autenticado: $user");

      notifyListeners();
    } catch (e) {
      throw Exception("Credenciales incorrectas o error al iniciar sesión");
    }
  }

  Future<void> logout() async {
    await _authService.logout();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    _isAuthenticated = false;
    notifyListeners();

  }
}
