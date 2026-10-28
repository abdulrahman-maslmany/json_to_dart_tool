import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_dart_tool/json_parser.dart';

void main() {
  group('JsonParser Class Generation Tests', () {

    test('JsonParser generates valid model from flat map', () {
      final Map<String, dynamic> sampleMap = {
        'id': 1,
        'name': 'Flutter',
        'is_active': true,
      };

      // تمرير Map<String, dynamic> بالطريقة الصحيحة
      final result = JsonParser.generateDartClass('UserModel', sampleMap);

      expect(result, contains('class UserModel'));
      expect(result, contains('id;'));
      expect(result, contains('name;'));
      expect(result, contains('factory UserModel.fromJson'));
      expect(result, contains('Map<String, dynamic> toJson()'));
    });

    test('JsonParser handles nested object maps recursively', () {
      final Map<String, dynamic> nestedMap = {
        'user_id': 100,
        'profile': {
          'bio': 'Mobile Engineer',
          'city': 'Cairo',
        },
      };

      final result = JsonParser.generateDartClass('UserResponse', nestedMap);

      expect(result, contains('class UserResponse'));
      expect(result, contains('class Profile'));
      expect(result, contains('final Profile? profile;'));
      expect(result, contains('Profile.fromJson'));
    });

    test('JsonParser handles lists of primitives and objects', () {
      final Map<String, dynamic> listMap = {
        'tags': ['dart', 'flutter'],
        'scores': [95, 100],
      };

      final result = JsonParser.generateDartClass('TagsResponse', listMap);

      expect(result, contains('tags;'));
      expect(result, contains('scores;'));
    });

    test('JsonParser handles empty map payload safely', () {
      final Map<String, dynamic> emptyMap = {};
      final result = JsonParser.generateDartClass('EmptyModel', emptyMap);

      expect(result, contains('class EmptyModel'));
    });
  });
}
