import 'package:flutter/material.dart';
import 'qr_types.dart';

typedef OnCreatedCallback = void Function(QRViewController controller);

class QRPlatformView extends StatelessWidget {
  final OnCreatedCallback onQRViewCreated;

  const QRPlatformView({super.key, required this.onQRViewCreated});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => onQRViewCreated(QRViewController()));
    return const Center(
      child: Text(
        'QR scanning is not available on web in this build.\n'
        'Please use Android, iOS, or Windows desktop.',
        textAlign: TextAlign.center,
      ),
    );
  }
}


