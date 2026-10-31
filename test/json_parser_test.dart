import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_dart_tool/json_exceptions.dart';

void main() {
  group('JsonParser & Exceptions Unit Test Suite', () {
    test('JsonParseException stringifies message correctly', () {
      const exception = JsonParseException(
        'Invalid format at line 4',
        'Unexpected token',
      );
      expect(exception.toString(), contains('Invalid format at line 4'));
      expect(exception.toString(), contains('Unexpected token'));
    });

    test('Validates flat JSON map parsing and type detection', () {
      const rawJson = '{"id": 101, "title": "Dart Model", "is_valid": true}';
      final Map<String, dynamic> data = jsonDecode(rawJson);

      expect(data['id'], equals(101));
      expect(data['title'], equals('Dart Model'));
      expect(data['is_valid'], isTrue);
    });

    test('Validates nested object structure deserialization', () {
      const nestedJson =
          '{"user": {"name": "Abdulrahman", "role": "Engineer"}}';
      final Map<String, dynamic> data = jsonDecode(nestedJson);

      expect(data['user'], isA<Map>());
      expect(data['user']['name'], equals('Abdulrahman'));
    });

    test('Validates list of objects parsing bounds', () {
      const listJson = '{"items": [{"id": 1}, {"id": 2}, {"id": 3}]}';
      final Map<String, dynamic> data = jsonDecode(listJson);

      expect(data['items'], isA<List>());
      expect((data['items'] as List).length, equals(3));
    });

    test('Throws FormatException on malformed payload string', () {
      expect(
        () => jsonDecode('{malformed_json}'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
