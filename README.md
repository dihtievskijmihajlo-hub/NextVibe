# NextVibe 🎬

Modern video streaming app like TikTok, built with Flutter.

## Features ✨

- 📱 Vertical scrolling video feed (TikTok style)
- ▶️ Built-in video player
- ⚡ Playback speed control (0.5x, 1x, 1.5x, 2x)
- ❤️ Like and comment system
- 🎯 Share functionality
- 🎨 Dark theme
- 📱 Works on Android and iOS

## Installation

### Requirements
- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio / Xcode

### Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/dihtievskijmihajlo-hub/NextVibe.git
   cd NextVibe
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Clean build:**
   ```bash
   flutter clean
   ```

4. **Run on Android:**
   ```bash
   flutter run
   ```

5. **Run on iOS:**
   ```bash
   cd ios
   rm -rf Pods
   rm Podfile.lock
   cd ..
   flutter pub get
   flutter run -d ios
   ```

## Build APK (Android)

```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

## Build for iOS

```bash
flutter build ios --release
```

## Project Structure

```
NextVibe/
├── lib/
│   └── main.dart          # Main app file
├── android/               # Android configuration
├── ios/                   # iOS configuration
├── pubspec.yaml           # Dependencies
└── README.md              # This file
```

## Technologies

- **Flutter** - UI framework
- **Video Player** - Video playback
- **Dart** - Programming language

## Features Included

✅ TikTok-style vertical video feed
✅ Playback speed selector (0.5x, 1x, 1.5x, 2x)
✅ Like/Unlike functionality
✅ Comments and share buttons
✅ Gradient overlay for better text visibility
✅ Error handling and retry functionality
✅ Dark theme UI
✅ Works on both Android and iOS

## License

MIT License

## Author

NextVibe Team 🚀