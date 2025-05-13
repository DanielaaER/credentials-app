import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_school_app/services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/qr_widget.dart';

class CredentialScreen extends StatefulWidget {
  const CredentialScreen({super.key});

  @override
  State<CredentialScreen> createState() => _CredentialScreenState();
}

class _CredentialScreenState extends State<CredentialScreen> {
  Map<String, dynamic>? usuario;
  bool isLoading = true;
  late String currentTime;

  String userType = '';

  Future<void> _fetchUserType() async {
    final tipo = await AuthService().getUserType();
    print('Tipo de usuario: $tipo');
    if (!mounted) return;
    setState(() {
      userType = tipo!.trim();  // trimear elimina espacios inesperados
    });
  }


  @override
  void initState() {
    super.initState();

    _loadUserData();
    _fetchUserType();
    _secureScreen();
    _startClock();
  }



  void _startClock() {
    currentTime = _getFormattedTime();
    Stream.periodic(const Duration(seconds: 1)).listen((_) {
      if (mounted) {
        setState(() {
          currentTime = _getFormattedTime();
        });
      }
    });
  }

  String _getFormattedTime() {
    return DateFormat.Hms().format(DateTime.now());
  }

  Future<void> _secureScreen() async {
    }

  Future<void> _loadUserData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/usuario.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        final data = jsonDecode(content);
        setState(() {
          usuario = data;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error leyendo usuario.json: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Credencial Digital')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : usuario == null
          ? const Center(child: Text('No se encontraron datos del usuario.'))
          : Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: theme.cardColor,
          child: Container(
            width: 340,
            height: 520,
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    usuario!['foto'] != null
                        ? CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(usuario!['foto']),
                    )
                        : const CircleAvatar(
                      radius: 45,
                      backgroundColor: AppTheme.primaryColor,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${usuario!['nombre']} ${usuario!['apellido_pat']} ${usuario!['apellido_mat']}',
                      style: theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text('No. Control: ${usuario!['num_control']}'),

                    if (userType == 'estudiante')
                      Text('Carrera: ${usuario!['carrera']}'),

                    if (userType == 'estudiante')
                      Text('Semestre: ${usuario!['semestre'].toString()}'),

                    if (userType == 'docente')
                      Text('Periodo: ${usuario!['periodo'].toString()}'),



                    const Spacer(),
                    const Text('Código QR Institucional'),
                    const SizedBox(height: 8),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.lightBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:  SizedBox(
                          height: 160,
                          width: 160,
                          child: QRWidget(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Text(
                    currentTime,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/');
          }
        },
      ),
    );
  }
}
