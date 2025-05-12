import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../services/auth_service.dart';
import '../utils/theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? usuario;
  bool isLoading = true;
  String userType = '';

  void getUserType() {
    userType = AuthService().getUserType() as String;
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final blob = Uint8List.fromList(bytes);
        await AuthService().loadProfile(blob);
        setState(() {
          usuario!['foto'] = pickedFile.path;
        });
      }
    } catch (e) {
      print('Error seleccionando la foto: \$e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error leyendo usuario.json: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildInfoRow(IconData icon, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$label: ${value.toString()}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    final cols = Theme.of(context).colorScheme;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : usuario == null
          ? const Center(child: Text('No se encontraron datos del usuario.'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              // elevation: 6,
              color: cols.background,
              // shadowColor: Colors.purpleAccent.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: (){

                        },
                        child: usuario!['foto'] != null
                            ? CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(File(usuario!['foto'])),
                        )
                            : CircleAvatar(
                          radius: 50,
                          backgroundColor: cols.primary,
                          child: Icon(Icons.person, size: 60, color: cols.background),
                        ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${usuario!['nombre']} ${usuario!['apellido_pat']} ${usuario!['apellido_mat']}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow(Icons.badge, 'No. Control', usuario!['num_control']),
                    if (userType == 'estudiante')
                      _buildInfoRow(Icons.school, 'Carrera', usuario!['carrera']),
                    if (userType == 'estudiante')
                      _buildInfoRow(Icons.calendar_today, 'Semestre', usuario!['semestre']),
                    if (userType == 'docente')
                      _buildInfoRow(Icons.calendar_today, 'Periodo', usuario!['periodo']),
                    _buildInfoRow(Icons.phone, 'Teléfono', usuario!['telefono']),
                    _buildInfoRow(Icons.home, 'Dirección', usuario!['direccion']),
                    _buildInfoRow(Icons.email, 'Email', usuario!['email']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/credencial');
          }
        },
      ),
    );
  }
}
