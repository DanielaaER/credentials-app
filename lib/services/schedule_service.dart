import 'package:dio/dio.dart';
import 'package:flutter_school_app/providers/auth_provider.dart';
import 'package:flutter_school_app/services/auth_service.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ScheduleService {

  static final ScheduleService _instance = ScheduleService._internal();

  factory ScheduleService() {
    return _instance;
  }

  ScheduleService._internal();




  final Dio _dio = AuthService().dio;
  Future<List<dynamic>> fetchHorario() async {
    var token = AuthService().getToken();
    try {
      final id = await AuthService().getUserId();
      final response = await _dio.get(
        '/horarios/usuario/${id}/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        await _saveHorarioLocally(response.data);

        return response.data;
      } else {
        throw Exception('Horario inválido');
      }
    } catch (e) {
      print('Error en fetchHorario: $e');
      return await _loadHorarioLocally(); // fallback offline
    }
  }

  Future<void> _saveHorarioLocally(dynamic data) async {
    final file = await _getHorarioFile();
    await file.writeAsString(jsonEncode(data));

  }

  Future<List<dynamic>> _loadHorarioLocally() async {
    final file = await _getHorarioFile();
    if (await file.exists()) {
      final content = await file.readAsString();
      return jsonDecode(content);
    } else {
      throw Exception('No hay horario guardado localmente');
    }
  }

  Future<File> _getHorarioFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/horario.json');
  }
}
