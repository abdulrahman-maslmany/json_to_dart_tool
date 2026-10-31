import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_dart_tool/json_parser.dart';
import 'package:json_to_dart_tool/json_exceptions.dart';

void main() {
  group('JsonParser Generation & Security Suite', () {

    test('JsonSecurityValidator permits valid payloads under size boundary', () {
      const validPayload = '{"title": "Valid Sample"}';
      expect(() => JsonSecurityValidator.validate(validPayload), returnsNormally);
    });

    test('JsonSecurityValidator throws EmptyInputException on whitespace', () {
      expect(() => JsonSecurityValidator.validate('   '), throwsA(isA<EmptyInputException>()));
    });

    test('JsonSecurityValidator throws OversizedInputException on huge inputs', () {
      final hugePayload = 'a' * 100001;
      expect(() => JsonSecurityValidator.validate(hugePayload), throwsA(isA<OversizedInputException>()));
    });

    test('Generates complete Dart model class with fromJson and toJson', () {
      final Map<String, dynamic> payload = {
        'user_name': 'Maslmany',
        'is_verified': true,
        'rating': 4.9,
      };

      final generated = JsonParser.generateDartClass('DeveloperProfile', payload);

      expect(generated, contains('class DeveloperProfile'));
      expect(generated, contains('final String? userName;'));
      expect(generated, contains('final bool? isVerified;'));
      expect(generated, contains('final double? rating;'));
      expect(generated, contains('factory DeveloperProfile.fromJson'));
      expect(generated, contains('Map<String, dynamic> toJson()'));
    });
  });
}
