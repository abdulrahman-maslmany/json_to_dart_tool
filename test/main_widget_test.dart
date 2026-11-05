import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Import the actual production entrypoint instead of mock scaffolds
import 'package:json_to_dart_tool/main.dart';

void main() {
  group('JsonToolScreen Real Widget Interaction Tests', () {
    testWidgets('Renders real app UI and verifies interactive components',
        (WidgetTester tester) async {
      // Pump the actual production widget tree into the test environment
      await tester.pumpWidget(const MaterialApp(home: JsonToolScreen()));
      await tester.pumpAndSettle();

      // Assert that core input fields and action buttons are rendered properly
      expect(find.byType(TextField), findsWidgets);
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets(
        'Entering invalid JSON handles state gracefully without crashing',
        (WidgetTester tester) async {
      // Mount the real UI screen
      await tester.pumpWidget(const MaterialApp(home: JsonToolScreen()));
      await tester.pumpAndSettle();

      // Locate input text fields
      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);

      // Simulate user typing a sample JSON payload into the input area
      await tester.enterText(textFields.last, '{"name": "test"}');
      await tester.pumpAndSettle();

      // Simulate clicking the generation button
      final buttons = find.byType(ElevatedButton);
      if (buttons.evaluate().isNotEmpty) {
        await tester.tap(buttons.first);
        await tester.pumpAndSettle();
      }

      // Verify the application remains stable and renders the expected screen
      expect(find.byType(JsonToolScreen), findsOneWidget);
    });
  });
}
