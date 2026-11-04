import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_dart_tool/controllers/json_tool_controller.dart';

void main() {
  group('JsonToolController Tests', () {
    late JsonToolController controller;

    setUp(() {
      controller = JsonToolController();
    });

    test('generate fails gracefully on empty input', () {
      final success = controller.generate('', 'Model');
      expect(success, isFalse);
      expect(controller.errorMessage, isNotNull);
    });

    test('generate succeeds on valid JSON', () {
      final success = controller.generate('{"key": "value"}', 'TestModel');
      expect(success, isTrue);
      expect(controller.generatedCode, contains('class TestModel'));
    });
  });
}
