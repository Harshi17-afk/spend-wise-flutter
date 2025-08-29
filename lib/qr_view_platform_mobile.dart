import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

typedef OnCreatedCallback = void Function(QRViewController controller);

class QRPlatformView extends StatelessWidget {
  final OnCreatedCallback onQRViewCreated;

  const QRPlatformView({super.key, required this.onQRViewCreated});

  @override
  Widget build(BuildContext context) {
    return QRView(
      key: GlobalKey(debugLabel: 'QR'),
      onQRViewCreated: onQRViewCreated,
    );
  }
}


