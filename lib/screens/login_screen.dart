
import 'package:flutter/material.dart';
import 'package:flutter_school_app/providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../utils/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  final _auth = AuthProvider();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });

    try {
      await _auth.login(_emailCtrl.text.trim(), _passCtrl.text.trim());
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      setState(() => _error = 'Credenciales inválidas');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cols = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(children: [
        // Fondo degradado
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cols.background, AppTheme.primaryColor.withOpacity(0.3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Logo o icono de la app
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cols.primary,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: cols.primary.withOpacity(0.4), blurRadius: 12)],
                  ),
                  child: const Icon(Icons.school, size: 48, color: Colors.white),
                ),
                const SizedBox(height: 24),

                // Card con el formulario
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text('Iniciar Sesión',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: cols.primary
                              )),
                          const SizedBox(height: 24),

                          // Email
                          TextFormField(
                            controller: _emailCtrl,
                            style: TextStyle(color: cols.primary),
                            decoration: InputDecoration(

                              prefixIcon:
                              Icon(Icons.confirmation_number_outlined, color: cols.primary),
                              hintText: 'Número de control',
                              hintStyle:TextStyle(color: cols.primary),
                              filled: true,
                              fillColor: AppTheme.lightBackground,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Requerido';
                              if (v.length < 10)
                                return 'Mínimo 10 caracteres';
                              if (v.length > 10)
                                return 'Máximo 10 caracteres';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Contraseña
                          TextFormField(
                            controller: _passCtrl,
                            obscureText: true,
                            style: TextStyle(color: cols.primary),
                            decoration: InputDecoration(

                              prefixIcon:
                              Icon(Icons.lock, color: cols.primary),
                              hintText: 'Contraseña',
                              hintStyle:TextStyle(color: cols.primary),
                              filled: true,
                              fillColor: AppTheme.lightBackground,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Requerido';
                              if (v.length < 6)
                                return 'Mínimo 6 caracteres';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          if (_error != null)
                            Text(_error!,
                                style: TextStyle(color: cols.error)),
                          const SizedBox(height: 16),

                          // Botón
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cols.primary,
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _loading
                                  ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: cols.onPrimary,
                                  strokeWidth: 3,
                                ),
                              )
                                  : Text('Entrar',
                                  style: TextStyle(
                                      color: cols.onPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                // Olvidé mi contraseña
                TextButton(
                  onPressed: () {},
                  child: Text('¿Olvidaste tu contraseña?',
                      style: TextStyle(color: cols.secondary)),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
