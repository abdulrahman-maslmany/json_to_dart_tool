import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

// اختبارات منطق تحليل الـ JSON وتوليد كلاسات Dart
void main() {
  group('JSON to Dart Parser Unit Tests', () {

    test('Parses flat JSON key-value pairs properly', () {
      const jsonString = '{"id": 101, "name": "Flutter Developer", "isActive": true}';
      final Map<String, dynamic> data = jsonDecode(jsonString);

      expect(data['id'], equals(101));
      expect(data['name'], equals('Flutter Developer'));
      expect(data['isActive'], isTrue);
    });

    test('Handles nested JSON objects structure', () {
      const jsonString = '''
      {
        "user": {
          "firstName": "John",
          "address": { "city": "Cairo" }
        }
      }
      ''';
      final Map<String, dynamic> data = jsonDecode(jsonString);

      expect(data['user'], isNotNull);
      expect(data['user']['address']['city'], equals('Cairo'));
    });

    test('Parses list of primitives and list of objects correctly', () {
      const jsonString = '''
      {
        "tags": ["dart", "flutter", "mobile"],
        "scores": [10, 20, 30]
      }
      ''';
      final Map<String, dynamic> data = jsonDecode(jsonString);

      expect(data['tags'], isA<List>());
      expect((data['tags'] as List).length, equals(3));
      expect((data['scores'] as List).first, equals(10));
    });

    test('Validates camelCase formatting logic', () {
      String toCamelCase(String text) {
        final parts = text.split('_');
        if (parts.length <= 1) return text;
        return parts.first + parts.skip(1).map((w) => w[0].toUpperCase() + w.substring(1)).join();
      }

      expect(toCamelCase('user_profile_id'), equals('userProfileId'));
      expect(toCamelCase('first_name'), equals('firstName'));
    });

    test('Handles empty and invalid JSON gracefully', () {
      expect(() => jsonDecode(''), throwsA(isA<FormatException>()));
      expect(() => jsonDecode('{invalid}'), throwsA(isA<FormatException>()));
    });
  });
}
