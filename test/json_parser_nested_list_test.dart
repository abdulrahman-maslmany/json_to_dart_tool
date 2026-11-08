import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_dart_tool/json_parser.dart';

void main() {
  group('JsonParser - Complex Nested Collections Suite', () {
    test('Correctly handles nested arrays of primitive types', () {
      final Map<String, dynamic> payload = {
        'matrix': [
          [1, 2],
          [3, 4]
        ],
        'tags': ['mobile', 'flutter']
      };

      final result = JsonParser.generateDartClass('MatrixModel', payload);
      expect(result, isNotEmpty);
      expect(result.contains('class MatrixModel'), isTrue);
      expect(result.contains('List'), isTrue);
    });

    test('Correctly handles nested lists of complex objects', () {
      final Map<String, dynamic> payload = {
        'departments': [
          {
            'name': 'Engineering',
            'members': [
              {'id': 101, 'role': 'Architect'}
            ]
          }
        ]
      };

      final result = JsonParser.generateDartClass('CompanyModel', payload);
      expect(result, isNotEmpty);
      expect(result.contains('class CompanyModel'), isTrue);
      expect(result.contains('fromJson'), isTrue);
      expect(result.contains('toJson'), isTrue);
    });
  });
}