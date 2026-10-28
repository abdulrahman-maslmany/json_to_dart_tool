import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_dart_tool/json_parser.dart';

void main() {
  group('JsonParser Real Class Integration Suite', () {

    test('JsonParser generates valid Dart model class from flat JSON', () {
      const sampleJson = '{"id": 1, "name": "Flutter", "is_active": true}';
      
      // استدعاء دالة الكلاس الفعلية من مشروعك
      final result = JsonParser.generateDartClass('UserModel', sampleJson);

      expect(result, contains('class UserModel'));
      expect(result, contains('final int? id;'));
      expect(result, contains('final String? name;'));
      expect(result, contains('final bool? isActive;')); // camelCase verification
      expect(result, contains('factory UserModel.fromJson'));
      expect(result, contains('Map<String, dynamic> toJson()'));
    });

    test('JsonParser handles nested JSON objects recursively', () {
      const nestedJson = '''
      {
        "user_id": 100,
        "profile": {
          "bio": "Mobile Engineer",
          "city": "Cairo"
        }
      }
      ''';

      final result = JsonParser.generateDartClass('UserResponse', nestedJson);

      expect(result, contains('class UserResponse'));
      expect(result, contains('class Profile'));
      expect(result, contains('final Profile? profile;'));
      expect(result, contains('Profile.fromJson'));
    });

    test('JsonParser handles lists of primitive values and custom objects', () {
      const listJson = '''
      {
        "tags": ["dart", "flutter"],
        "scores": [95, 100]
      }
      ''';

      final result = JsonParser.generateDartClass('TagsResponse', listJson);

      expect(result, contains('final List<String>? tags;'));
      expect(result, contains('final List<int>? scores;'));
    });

    test('JsonParser catches invalid malformed JSON gracefully', () {
      const invalidJson = '{invalid_json}';
      final result = JsonParser.generateDartClass('ErrorModel', invalidJson);

      // التأكد من معالجة الخطأ
      expect(result.toLowerCase(), contains('error'));
    });
  });
}
