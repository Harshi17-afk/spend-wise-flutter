// Dummy stand-ins for web so code type-checks without the native plugin
import 'dart:async';

class Barcode {
  final String? code;
  const Barcode({this.code});
}

class QRViewController {
  Stream<Barcode> get scannedDataStream => const Stream.empty();
  void dispose() {}
}


