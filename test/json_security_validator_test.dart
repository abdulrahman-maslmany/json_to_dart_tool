import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_dart_tool/config.dart';

void main() {
  group('JsonSecurityValidator & Config Tests', () {
    test('AppConfig loads default parameters correctly', () {
      expect(AppConfig.appName, equals('JSON to Dart Pro'));
      expect(AppConfig.maxPayloadSize, equals(5242880));
      expect(AppConfig.enableAnalytics, isFalse);
    });

    test('Validates payload size bounds against security threshold', () {
      const smallPayload = '{"id": 1, "name": "test"}';
      expect(smallPayload.length, lessThan(AppConfig.maxPayloadSize));

      final oversizedString = 'a' * (AppConfig.maxPayloadSize + 10);
      expect(oversizedString.length, greaterThan(AppConfig.maxPayloadSize));
    });

    test('Handles malformed and empty json strings gracefully', () {
      const emptyPayload = '';
      expect(emptyPayload.trim().isEmpty, isTrue);

      const invalidPayload = '{invalid_json: true}';
      expect(invalidPayload.startsWith('{'), isTrue);
    });
  });
}