import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_dart_tool/controllers/json_tool_controller.dart';

void main() {
  group('JsonToolController Unit Tests', () {
    late JsonToolController controller;

    setUp(() {
      // Re-initialize a fresh controller instance before each test execution
      controller = JsonToolController();
    });

    test('generate fails gracefully on empty input', () {
      // Verify empty strings do not trigger unhandled exceptions
      final success = controller.generate('', 'Model');
      expect(success, isFalse);
      expect(controller.errorMessage, isNotNull);
    });

    test('generate fails on malformed JSON syntax', () {
      // Verify invalid JSON syntax is safely caught and formatted as an error message
      final success = controller.generate('{"broken_json": ', 'Model');
      expect(success, isFalse);
      expect(controller.errorMessage, isNotNull);
    });

    test('generate succeeds on valid JSON map payload', () {
      // Assert that valid JSON maps produce the expected class signature
      final success = controller.generate('{"key": "value"}', 'TestModel');
      expect(success, isTrue);
      expect(controller.generatedCode, contains('class TestModel'));
      expect(controller.errorMessage, isNull);
    });

    test('clear resets generated state and error messages', () {
      // Populate state then assert reset behavior
      controller.generate('{"key": "value"}', 'TestModel');
      controller.clear();

      expect(controller.generatedCode, isEmpty);
      expect(controller.errorMessage, isNull);
    });
  });
}
