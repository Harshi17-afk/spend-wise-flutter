// Provides a platform-safe alias for QRViewController
// On web, this is a dummy type to satisfy references without importing the plugin

export 'qr_types_mobile.dart'
  if (dart.library.html) 'qr_types_web.dart';


