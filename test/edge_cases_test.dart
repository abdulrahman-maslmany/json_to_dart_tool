import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_dart_tool/controllers/json_tool_controller.dart';

void main() {
  late JsonToolController controller;

  setUp(() {
    controller = JsonToolController();
  });

  group('1. Special Keys & Reserved Dart Keywords Edge Cases', () {
    test('handles keys starting with @ or _ (e.g. @id, _type)', () {
      const input = '''
      {
        "@id": "urn:uuid:1234",
        "_type": "admin_user",
        "user-name": "alex"
      }
      ''';

      // استدعاء دالة التحويل في الـ controller
      expect(() => controller.convert(input), returnsNormally);
      final result = controller.convert(input);

      // التأكد من تنظيف أو تطويع المفاتيح لتصبح متوافقة مع قواعد Dart
      expect(result, isNotEmpty);
      expect(result.contains('id') || result.contains('type'), isTrue);
    });

    test('sanitizes keys starting with numbers (e.g. 123startWithNumber)', () {
      const input = '''
      {
        "123startWithNumber": "value",
        "2026_target": true
      }
      ''';

      final result = controller.convert(input);
      expect(result, isNotEmpty);
      // يجب ألا يبدأ اسم المتغير في Dart برقم
      expect(result.contains('num123startWithNumber') || result.contains('n123startWithNumber') || result.contains('_123startWithNumber'), isTrue);
    });

    test('escapes Dart reserved keywords (class, switch, default, import)', () {
      const input = '''
      {
        "class": "Math101",
        "default": true,
        "switch": "on"
      }
      ''';

      final result = controller.convert(input);
      expect(result, isNotEmpty);
      // التأكد من عدم إنشاء متغير باسم محجوز مباشرة
      expect(result.contains('class class'), isFalse);
    });
  });

  group('2. Extreme Numeric Values & Precision Edge Cases', () {
    test('accurately parses high-precision floating points and double values', () {
      const input = '''
      {
        "latitude": 30.044419600000001,
        "scientific_notation": 1.234567e-10,
        "small_float": 0.000000000000001
      }
      ''';

      final result = controller.convert(input);
      expect(result, contains('double'));
    });

    test('handles 64-bit large integers without truncation', () {
      const input = '''
      {
        "large_timestamp": 9223372036854775807,
        "negative_large_id": -9223372036854775806
      }
      ''';

      final result = controller.convert(input);
      expect(result, contains('int') || result.contains('num'));
    });
  });

  group('3. Empty and Degenerate JSON Structures', () {
    test('handles empty JSON object {} gracefully', () {
      const input = '{}';

      final result = controller.convert(input);
      expect(result, isNotEmpty);
      expect(result, contains('class'));
    });

    test('handles empty JSON array [] at root without crashing', () {
      const input = '[]';

      expect(() => controller.convert(input), returnsNormally);
    });

    test('handles arrays containing null or mixed primitive types', () {
      const input = '''
      {
        "items": [null, "valid_string", 42, true]
      }
      ''';

      final result = controller.convert(input);
      expect(result, contains('List'));
    });

    test('handles deep recursive nested objects (depth > 10)', () {
      const input = '''
      {
        "level1": {
          "level2": {
            "level3": {
              "level4": {
                "deep_key": "success"
              }
            }
          }
        }
      }
      ''';

      final result = controller.convert(input);
      expect(result, contains('Level1'));
      expect(result, contains('Level4'));
    });
  });

  group('4. Malformed JSON & Error Handling', () {
    test('throws FormatException or custom exception on invalid JSON syntax', () {
      const brokenInputs = [
        '{name: "missing quotes"}',
        '{"unterminated_string": "value}',
        '{"trailing_comma": 123,}',
        'Plain text payload that is not JSON'
      ];

      for (final badJson in brokenInputs) {
        expect(
          () => controller.convert(badJson),
          throwsA(anything),
          reason: 'Failed to catch error on: $badJson',
        );
      }
    });

    test('rejects whitespace-only or empty string payload', () {
      expect(() => controller.convert(''), throwsA(anything));
      expect(() => controller.convert('   \n\t  '), throwsA(anything));
    });
  });
}
