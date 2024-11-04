# OmniSphereVault

A secure, cross-platform password manager built with Flutter, focusing on local storage and strong security features.

## Features

- Material 3 design with light/dark theme support
- Password generation with multiple modes (Standard, Memorable, PIN, Passphrase)
- Category management with custom icons and colors
- Password expiration tracking and notifications
- Secure clipboard handling
- Search and filtering capabilities
- Cross-platform support (Windows, Linux, Android)

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- For Linux:
  - GTK development headers
  - pkg-config

### Initial Setup

1. Clone the repository:
git clone https://github.com/yourusername/omnisphere_vault.git
cd omnisphere_vault


2. Install dependencies:
`flutter pub get`

3. Generate necessary files:
`flutter pub run build_runner build --delete-conflicting-outputs`

### Development Setup

1. Start the continuous code generation:
`flutter pub run build_runner watch`

2. Run the app:
`flutter run`

### Project Structure
lib/
├── core/
│ ├── enums/ # Common enums like StateStatus
│ ├── providers/ # Core providers (notification, storage)
│ └── services/ # Core services (storage, notifications)
├── features/
│ ├── auth/ # Authentication related code
│ ├── categories/ # Category management
│ ├── password_management/
│ │ ├── models/ # Password-related models
│ │ ├── providers/ # State management
│ │ ├── views/ # UI components
│ │ └── widgets/ # Reusable widgets
│ └── settings/ # App settings
└── main.dart


### Development Workflow

1. Make changes to your code
2. The `build_runner watch` command will automatically generate necessary files
3. Use `flutter run` to test your changes
4. Before committing, run:
`flutter analyze`
`flutter test`


### Common Development Tasks

#### Adding a New Model
1. Create the model file with freezed annotations
2. Run build_runner to generate the code
3. Import and use the model in your features

#### Creating a New Feature
1. Create a new directory under `lib/features`
2. Add models, providers, views, and widgets directories
3. Implement the feature using the MVVM pattern
4. Update the relevant providers

#### Implementing State Management
1. Create a state class using freezed
2. Create a StateNotifier class
3. Create a provider
4. Use ConsumerWidget or ConsumerStatefulWidget in your UI

## Current Status

See [TODO.md](TODO.md) for current development status and upcoming tasks.
See [APP_DOCS.md](APP_DOCS.md) for detailed documentation.

## Troubleshooting

### Common Issues

1. **Build Runner Issues**
   ```bash
   flutter clean
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **State Management Issues**
   - Ensure providers are properly scoped
   - Check for proper provider watching/reading
   - Verify state updates are triggering rebuilds

3. **Platform-Specific Issues**
   - Linux: Ensure GTK development headers are installed
   - Windows: Check for Visual Studio Build Tools
   - Android: Verify SDK installation

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Riverpod for state management
- All contributors who help improve this project