# Responsive Admin Panel with Flutter

## 🚀 Overview
A modern, responsive admin panel built with Flutter using clean architecture principles. This project provides a robust foundation for building scalable admin dashboards with features like user authentication, role-based access control, and data visualization.

## ✨ Features

### Core Features
- **Responsive Layout**: Adapts seamlessly to all device sizes
- **Authentication System**: Secure user login with Firebase Authentication
- **Theme Support**: Light and dark theme modes with persistence
- **Multi-language Support**: Built-in internationalization support
- **Clean Architecture**: Well-structured project following clean architecture principles

### Dashboard
- Interactive data visualization with charts and graphs
- Real-time data updates
- Customizable widgets

### User Management
- User authentication and authorization
- Profile management
- Role-based access control

### Technical Stack
- **Framework**: Flutter 3.x
- **State Management**: Provider + BLoC Pattern
- **Navigation**: Go Router for declarative routing
- **Local Storage**: Shared Preferences for local data persistence
- **Charts**: fl_chart for beautiful data visualization
- **Dependency Injection**: GetIt for service location
- **Networking**: Dio for HTTP requests

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK (>=3.8.0 <4.0.0)
- Firebase account (for authentication)
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/responsive_admin_panel_flutter.git
   cd responsive_admin_panel_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Add Android/iOS/Web app to your Firebase project
   - Download the configuration files and place them in the appropriate directories
   - Enable Email/Password authentication in Firebase Console

4. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
lib/
├── core/               # Core functionality
│   ├── constants/      # App-wide constants
│   ├── errors/         # Custom exceptions and error handling
│   ├── network/        # Network-related code
│   ├── theme/          # App theming
│   └── utils/          # Utility functions and extensions
│
├── features/          # Feature modules
│   ├── auth/           # Authentication feature
│   ├── dashboard/      # Dashboard feature
│   ├── shared/         # Shared components and providers
│   ├── splash/         # Splash screen
│   └── user/           # User management
│
├── l10n/              # Localization files
├── routes/             # App routing configuration
└── main.dart           # App entry point
```

## 🎨 Theming

The app supports both light and dark themes. The theme can be toggled from the settings screen. Theme preferences are persisted locally.

## 🌐 Internationalization

This project includes internationalization support. To add a new language:
1. Add a new JSON file in `lib/l10n/`
2. Update the `supportedLocales` in `main.dart`
3. Add the translations to the new locale file

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Code Style
- Follow the official [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- Use meaningful commit messages
- Write tests for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) for the amazing cross-platform framework
- [Firebase](https://firebase.google.com/) for backend services
- All the amazing package authors whose work made this project possible

---

<div align="center">
  Made with ❤️ using Flutter
</div>

