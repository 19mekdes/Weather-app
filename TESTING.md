Testing the Weather App (GPS & Web)

Quick steps to test location-based features on different platforms.

Android
- Ensure a device or emulator has location enabled.
- If using an Android emulator, set a mock location in the emulator settings.
- Run:
```bash
flutter run -d <device-id>
```
- When prompted, grant location permission. If denied, use the "Open Settings" button in the app or enable permissions from system Settings.

iOS (simulator or device)
- For a simulator, use `Features > Location` to simulate a location or select a custom GPX file.
- On a real device, ensure Location Services are enabled and grant permission when the prompt appears.
- Run:
```bash
flutter run -d <device-id>
```

Web
- Web browsers block some third-party APIs via CORS. The app avoids reverse-geocoding on web and will display coordinates instead.
- To test web behavior:
```bash
flutter run -d chrome
```
- In Chrome, you can mock geolocation: DevTools > Sensors > Geolocation.

Notes & Troubleshooting
- If the app shows a location error, use "Retry" or "Open Settings" in the app.
- For production web support of reverse-geocoding, run a small backend proxy (serverless function) to call the geocoding API and return results with proper CORS headers.

Additional checks
- Confirm `android/app/src/main/AndroidManifest.xml` contains location permissions.
- Confirm `ios/Runner/Info.plist` has `NSLocationWhenInUseUsageDescription`.
