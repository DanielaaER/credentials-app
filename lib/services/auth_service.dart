import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';
class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }


  late final Dio _dio;
  Dio get dio => _dio;
  AuthService._internal() {
    _dio = Dio(BaseOptions(baseUrl: 'http://20.161.24.92:8000/api'))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!options.path.endsWith('/login/')) {
            final token = await getToken();
            print('Token: $token');
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
      ));
  }

  static const _userFileName = 'usuario.json';


  Future<bool> loadProfile (Uint8List foto) async {
    try {
      final user = await getSavedUser();
      if (user == null) {
        throw Exception('No se encontraron datos de usuario guardados');
      }
      var userType = await getUserType();
      final response = await _dio.patch(
        '/usuarios/update/${userType}/${user['id']}',
        data: {'foto': foto.toString()},
      );
      if (response.statusCode == 200) {
        await _saveUserData(response.data);
        return true;
      } else {
        throw Exception('Error al cargar la foto de perfil');
      }
    } catch (e) {
      print('Error al cargar la foto de perfil: $e');
      return false;
    }
  }


  Future<Map<String, dynamic>> login(
      String num_control, String password) async {
    try {
      final response = await _dio.post(
        '/login/',
        data: {'num_control': num_control, 'password': password},
      );
      print(
          'Response: ${response.data}');
      if (response.statusCode == 200 && response.data != null) {
        final token = response.data["data"]['access_token'];
        final prefs = await SharedPreferences.getInstance();

        print('Token guardado: $token');
        await prefs.setString('token', token);
        final userData = await getUser(response.data["data"]['user']);
        await _saveUserData(userData);

        return userData;
      } else {
        throw Exception('Login inválido');
      }
    } catch (e) {
      print('Login error: $e');
      final localUser = await getSavedUser();
      if (localUser != null) {
        return localUser; // Retorna los datos locales si no hay conexión
      } else {
        throw Exception('No se pudo iniciar sesión ni cargar datos locales');
      }
    }
  }

  Future<Map<String, dynamic>> getUser(int id) async {
    try {
      final response = await _dio.get('/usuario/$id');
      print(
          'Response: ${response.data}'); // Imprimir la respuesta para depuración
      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      } else {
        throw Exception('Error al obtener los datos del usuario');
      }
    } catch (e) {
      print('Error al obtener el usuario: $e');
      throw e; // Propagar el error
    }
  }

  // obtner el id del usuario
  Future<int?> getUserId() async {
    final user = await getSavedUser();
    return user?['id']; // Obtener el ID del usuario guardado
  }

  // obtener el tipo de usuario
  Future<String?> getUserType() async {
    final user = await getSavedUser();
    if (user == null) {
      return null; // Si no hay usuario guardado, retornar null
    }
    if (user?["semestre"] != null) {
      return 'estudiante'; // Retornar 'alumno' si el tipo es alumno
    } else if (user?["periodo"] != null) {
      return 'docente'; // Retornar 'profesor' si el tipo es profesor
    } else
      return 'administrador'; // Retornar 'administrador' si el tipo es administrador
  }

  Future<void> logout() async {
    final file = await _getUserFile();
    if (await file.exists()) {
      await file.delete(); // Eliminar el archivo de datos del usuario
    }
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final file = await _getUserFile();
    await file.writeAsString(
        jsonEncode(userData)); // Guardar los datos de usuario en un archivo
  }

  Future<Map<String, dynamic>?> getSavedUser() async {
    final file = await _getUserFile();
    if (await file.exists()) {
      final content =
          await file.readAsString(); // Leer el contenido del archivo
      return jsonDecode(content);
    }
    return null; // Si no existe el archivo, no hay datos guardados
  }

  Future<String?> getToken() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<File> _getUserFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$_userFileName';
    return File(path);
  }
}
