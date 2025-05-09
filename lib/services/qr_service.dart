import 'package:dio/dio.dart';
import 'package:flutter_school_app/services/auth_service.dart';

import '../providers/auth_provider.dart';

class QRService {


  static final QRService _instance = QRService._internal();

  factory QRService() {
    return _instance;
  }

  QRService._internal();

  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'http://20.161.24.92:8000/api'));

  Future<String> fetchQRToken() async {
    try {

      final id = await AuthService().getUserId();
      final tipo = await AuthService().getUserType();
      print('ID: $id');
      print('Tipo: $tipo');
      final response = await _dio.post('/qr/generar', data: {
        'tipo': tipo,
        'id': id,
      });

      if (response.statusCode == 200 && response.data != null) {
        return response.data.toString();
      } else {
        throw Exception('Respuesta inválida del servidor');
      }
    } catch (e) {
      print('Error al obtener QR token: $e');
      throw Exception('No se pudo obtener el token QR');
    }
  }
}
