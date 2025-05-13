import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/qr_service.dart';

class QRWidget extends StatefulWidget {
  @override
  _QRWidgetState createState() => _QRWidgetState();
}

class _QRWidgetState extends State<QRWidget> {
  String qrData = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _generateQR();
    _timer = Timer.periodic(Duration(seconds: 30), (timer) => _generateQR());
  }

  Future<void> _generateQR() async {
    final token = await QRService().fetchQRToken();
    setState(() {
      qrData = token;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return qrData.isEmpty
        ? CircularProgressIndicator()
        : QrImageView(data: qrData, size: 200);
  }
}