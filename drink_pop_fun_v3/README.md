# วันนี้ดื่มไรดี? — Pop & Fun V0.3

Flutter source code for Web and Android from one codebase.

## Features
- 30 Thai drink recipes with ingredients and preparation steps
- Mood and office-task matching, with random selection
- Caffeine-free filter (cocoa/chocolate drinks conservatively marked caffeinated)
- Original vector cartoon cup drawn in Flutter CustomPainter (no external images)
- Animated randomize action
- Saved favorites using shared_preferences
- Responsive layout, Thai UI, offline recipes

## Setup
Install Flutter 3.22+ and Android SDK (for APK). In this folder:

```sh
flutter create --platforms=web,android .
flutter pub get
flutter run -d chrome
flutter build web --release
flutter build apk --release
```

Outputs: `build/web/` and `build/app/outputs/flutter-apk/app-release.apk`.

This is **source code**, not a prebuilt APK. It has not been compiled in this environment (Flutter SDK unavailable). Run `flutter analyze` and `flutter test` in your Flutter environment.

Ingredients are generic suggestions, not verified Villa Market stock or prices.
