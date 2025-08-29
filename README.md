# SpendWise - Flutter Expenditure Tracker

A comprehensive Flutter mobile application for tracking personal expenses with advanced features including QR code scanning, visual analytics, payment processing, and transaction management.

## Features

- 📱 **Cross-platform Support**: iOS & Android compatibility
- 📊 **Visual Analytics**: Interactive pie charts and spending visualization
- 📷 **QR Code Integration**: Quick expense entry via QR code scanning
- 💳 **Payment Processing**: Mobile payment functionality
- 💾 **Data Persistence**: Local storage with SharedPreferences
- 📱 **Transaction Management**: Complete transaction history and utilities
- 🔐 **Authentication**: Secure login system
- ⚙️ **Settings & Customization**: User preferences and spending thresholds
- 🌍 **Internationalization**: Multi-language support
- 🎨 **Modern UI**: Material Design with custom theming

## Dependencies

### Core Dependencies
- **qr_code_scanner** (^1.0.1): QR code scanning functionality
- **shared_preferences** (^2.0.13): Local data storage and persistence
- **intl** (^0.17.0): Internationalization and localization
- **pie_chart** (^5.0.0): Visual data representation with charts
- **cupertino_icons** (^1.0.6): iOS-style icons

### Development Dependencies
- **flutter_test**: Testing framework
- **flutter_lints** (^3.0.0): Code quality and linting

## Getting Started

### Prerequisites

- **Flutter SDK**: >=3.3.3 <4.0.0
- **Dart SDK**: Included with Flutter
- **Development Environment**: Android Studio, VS Code, or IntelliJ IDEA
- **Device/Emulator**: iOS Simulator or Android Emulator

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd spend-wise-flutter
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

### Platform-specific Setup

#### Android
- Ensure Android SDK is installed
- Enable USB debugging for physical devices

#### iOS
- Xcode installation required
- iOS Simulator or physical device with developer account

## Project Structure

```
lib/
├── buttons/                          # Custom button widgets
├── auth_service.dart                 # Authentication services
├── constants.dart                    # Application constants
├── login_screen.dart                 # User authentication UI
├── main.dart                         # Application entry point
├── main_screen.dart                  # Primary dashboard
├── pay_mobile_page.dart              # Mobile payment interface
├── payment_page.dart                 # Payment processing UI
├── qr_types.dart                     # QR code type definitions
├── qr_types_mobile.dart              # Mobile QR implementations
├── qr_types_web.dart                 # Web QR implementations
├── qr_view.dart                      # QR code viewing interface
├── qr_view_platform.dart             # Platform-specific QR handling
├── qr_view_platform_mobile.dart      # Mobile QR platform code
├── qr_view_platform_web.dart         # Web QR platform code
├── settings_page.dart                # User settings and preferences
├── spending_visualization_page.dart   # Analytics and charts
├── theme.dart                        # Application theming
├── threshold_dialog.dart             # Spending limit dialogs
├── transaction_history_page.dart     # Transaction management
└── transaction_utils.dart            # Transaction utilities
```

## Key Features

### 📊 Spending Visualization
- Interactive pie charts showing expense categories
- Visual analytics for better financial insights
- Spending pattern analysis

### 📷 QR Code Integration
- Cross-platform QR code scanning
- Quick expense entry via QR codes
- Platform-specific implementations for optimal performance

### 💳 Payment System
- Mobile payment processing
- Secure transaction handling
- Payment history tracking

### 🔐 Authentication & Security
- Secure user authentication
- Protected user data
- Session management

### ⚙️ Settings & Customization
- Spending threshold alerts
- User preference management
- Customizable themes and settings

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
