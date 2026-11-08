class AppConfig {
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'JSON to Dart Pro',
  );

  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'production',
  );

  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );

  static const int maxPayloadSize = int.fromEnvironment(
    'MAX_JSON_PAYLOAD_SIZE',
    defaultValue: 5242880, // 5MB limit
  );
}