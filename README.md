# SpendWise - Flutter Expenditure Tracker

A modern Flutter mobile application for tracking personal expenses with advanced features like QR code scanning and visual analytics.

## Features

- 📱 Cross-platform mobile app (iOS & Android)
- 📊 Visual expense analytics with pie charts
- 📷 QR code scanning for quick expense entry
- 💾 Local data persistence
- 🌍 Internationalization support
- 🎨 Modern Material Design UI

## Dependencies

- **qr_code_scanner**: QR code scanning functionality
- **shared_preferences**: Local data storage
- **intl**: Internationalization support
- **pie_chart**: Visual data representation

## Getting Started

### Prerequisites

- Flutter SDK (>=3.3.3)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/spend-wise-flutter.git
   cd spend-wise-flutter
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── buttons/          # Custom button widgets
├── auth_service.dart # Authentication services
├── constants.dart    # App constants
└── [other dart files]
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
