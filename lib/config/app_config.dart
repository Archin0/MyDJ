import 'package:flutter/foundation.dart';

/// Central place to keep runtime configuration values.
///
/// The API base URL can be overridden using
/// `--dart-define=API_BASE_URL=https://your-host` when running the app.
class AppConfig {
  AppConfig._();

  static final String apiBaseUrl = _resolveBaseUrl();

  static String _resolveBaseUrl() {
    const envBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (envBaseUrl.trim().isNotEmpty) {
      return envBaseUrl.trim();
    }

    if (kIsWeb) {
      return 'http://localhost:8000';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      // 10.0.2.2 maps to the host machine when using the Android emulator.
      return 'http://10.0.2.2:8000';
    }

    return 'http://localhost:8000';
  }
}
