import 'package:flutter/material.dart';

class WifiScreen extends StatelessWidget {
  final VoidCallback? onRetry;

  const WifiScreen({this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 100, color: Colors.grey),
              const SizedBox(height: 24),
              const Text(
                "Sin conexión a internet",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "Por favor verifica tu conexión y vuelve a intentarlo.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  if (onRetry != null) {
                    onRetry!();
                  } else {
                    // Recarga toda la app
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const WifiScreen()),
                    );
                  }
                },
                icon: Icon(Icons.refresh),
                label: Text("Reintentar"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
