import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_dart_tool/json_parser.dart';
import 'package:json_to_dart_tool/json_exceptions.dart';

void main() {
  group('JsonParser Deep Edge Cases Suite', () {
    test('JsonParser handles deeply nested 3-level maps safely', () {
      final Map<String, dynamic> deepNested = {
        'level1': {
          'level2': {'level3': 'Target Value'}
        }
      };

      final result = JsonParser.generateDartClass('RootResponse', deepNested);
      expect(result, contains('class RootResponse'));
      expect(result, contains('class Level1'));
      expect(result, contains('class Level2'));
    });

    test('JsonParser handles empty nested dictionaries without crashing', () {
      final Map<String, dynamic> emptyNested = {
        'metadata': <String, dynamic>{},
        'count': 0
      };

      final result =
          JsonParser.generateDartClass('EmptyNestedModel', emptyNested);
      expect(result, contains('class EmptyNestedModel'));
      expect(result, contains('final int? count;'));
    });

    test('JsonSecurityValidator enforces exact boundary length limit', () {
      final boundaryPayload = 'a' * 100000;
      expect(() => JsonSecurityValidator.validate(boundaryPayload),
          returnsNormally);

      final exceededPayload = 'a' * 100001;
      expect(() => JsonSecurityValidator.validate(exceededPayload),
          throwsA(isA<OversizedInputException>()));
    });
  });
}
