# Sandwich Shop

A simple Flutter app skeleton for a sandwich shop. The project separates business logic (pricing, orders) into repositories and keeps UI and styles in dedicated folders so the app can be extended into a full point-of-sale / ordering demo app.

Key features
- Order and pricing logic separated into repositories:
  - lib/repositories/order_repository.dart
  - lib/repositories/pricing_repository.dart
- Cross-platform Flutter app with a Windows desktop runner (windows/ folder included).
- Unit tests for repositories and a widget test scaffold (test/).

---

## Table of contents
- Project description
- Requirements & prerequisites
- Installation & setup
- Running the app
- Usage
- Running tests
- Project structure
- Known issues & future improvements
- Contributing
- Contact

---

## Project description

This project is a starter Flutter project for a sandwich shop application. It focuses on basic business logic (pricing and order management) separated from the UI, enabling easy extension and testing. The Windows runner is included so you can run it on Windows desktop out of the box.

---

## Requirements & prerequisites

- OS: Windows (project contains Windows runner). You can also target Android / iOS if you add platform folders and platform SDKs.
- Flutter SDK (stable channel recommended). Install from https://flutter.dev
- Git
- For Windows desktop:
  - Visual Studio with "Desktop development with C++" workload (for building the Windows desktop app)
- (Optional) Android Studio / Xcode if you plan to target Android / iOS

Verify install:
- flutter --version
- flutter doctor

---

## Installation & setup

1. Clone the repository
   - git clone https://github.com/Mattcodez21/sandwich_shop
   - cd sandwich_shop

2. Get dependencies
   - flutter pub get

3. Run platform-specific setup (Windows)
   - Ensure Visual Studio and required components are installed
   - Optional: flutter config --enable-windows-desktop

---

## Running the app

From the project root:

- Run on the default device (if a device is attached or desktop is enabled):
  - flutter run

- Run on Windows desktop explicitly:
  - flutter run -d windows

- Build release for Windows:
  - flutter build windows

- Run for other platforms (Android, iOS):
  - Ensure platform toolchains are installed and then:
  - flutter run -d chrome

---

## Usage

This starter app currently exposes core flows around pricing and orders through repository classes. Typical flows:

- Create or update an order (OrderRepository)
- Calculate item and order totals (PricingRepository)
- UI connects to repositories (look under lib/views/ and view_models/ for UI scaffolding and state management)

If you are expanding the UI:
- Edit lib/main.dart to change the app entry
- Add screens under lib/views/
- Add state management under lib/view_models/

Screenshots / GIFs
- Replace these with real images from your build. Example placeholders:
  - assets/screenshots/home.png
  - assets/screenshots/order_flow.gif

---

## Running tests

Run unit and widget tests with:
- flutter test

You can run an individual test file:
- flutter test test/repositories/order_repository_test.dart

Test files present:
- test/repositories/order_repository_test.dart
- test/repositories/pricing_repository_test.dart
- test/views/widget_test.dart

---

## Project structure

- lib/
  - main.dart — app entrypoint
  - repositories/
    - order_repository.dart — order management logic
    - pricing_repository.dart — pricing & calculations
  - view_models/ — app state and view models (MVVM / provider / bloc can be used)
  - views/ — UI screens & widgets
  - app_styles.dart — shared styles and theming
- windows/ — Windows desktop runner & native glue code
- test/ — unit and widget tests

Note: For full dependency list, open pubspec.yaml.

---

## Technologies & tools

- Flutter (Dart)
- Flutter test for unit/widget tests
- Windows desktop integration (native C++ runner files included)
- Recommended editor: Visual Studio Code or Android Studio

---

## Known issues & limitations

- Minimal UI scaffolding in this starter repo — expand views/view_models for production UI.
- Platform-specific code present only for Windows by default — add iOS/Android configuration if needed.
- No persistence (local DB or remote backend) included — consider adding SQLite, Hive, or an API layer.
- Additional features to consider:
  - Menu management UI
  - Cart persistence
  - Payment integration
  - User authentication & profiles
  - Automated integration tests

---

## Contributing

1. Fork the repository
2. Create a feature branch: git checkout -b feature/your-feature
3. Run tests & add new tests for changes
4. Submit a pull request with a clear description of changes

Please follow the project's coding style and include tests for new logic.

---

## Contact

Replace these placeholders with your details:

- Maintainer: Matthew Wards
- Email: up2213766@myport.ac.uk
- GitHub: https://github.com/MattCodez21

---
