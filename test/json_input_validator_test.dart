import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_dart_tool/json_input_validator.dart';

void main() {
  group('JsonInputValidator Unit Tests', () {
    test('Validates correct JSON map payload', () {
      const input = '{"status": "ok", "code": 200}';
      final result = JsonInputValidator.validate(input);

      expect(result.isValid, isTrue);
      expect(result.errorMessage, isNull);
      expect(result.parsedData['status'], equals('ok'));
    });

    test('Validates correct JSON array payload', () {
      const input = '[{"id": 1}, {"id": 2}]';
      final result = JsonInputValidator.validate(input);

      expect(result.isValid, isTrue);
      expect((result.parsedData as List).length, equals(2));
    });

    test('Rejects empty or whitespace-only input', () {
      final result = JsonInputValidator.validate('   ');

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('cannot be empty'));
    });

    test('Catches malformed syntax errors properly', () {
      final result = JsonInputValidator.validate('{bad_json: missing_quotes}');

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('Malformed JSON'));
    });
  });
}
