import 'package:flutter/material.dart';
import 'qr_types.dart';
import 'qr_view_platform.dart' as qr;

class QRViewExample extends StatefulWidget {
  final void Function(QRViewController) onQRViewCreated;

  const QRViewExample({super.key, required this.onQRViewCreated});

  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: qr.QRPlatformView(onQRViewCreated: widget.onQRViewCreated),
    );
  }
}