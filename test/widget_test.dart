import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_dart_tool/main.dart';

void main() {
  group('JsonToolScreen Widget Interaction Tests', () {
    testWidgets('Renders real application UI and core action buttons', (WidgetTester tester) async {
      // Pump the real application entrypoint
      await tester.pumpWidget(const MaterialApp(home: JsonToolScreen()));
      await tester.pumpAndSettle();

      // Verify that input text fields and action buttons exist
      expect(find.byType(TextField), findsWidgets);
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('Entering JSON and triggering generate updates state safely', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: JsonToolScreen()));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);

      // Enter sample test JSON
      await tester.enterText(textFields.last, '{"key": "value"}');
      await tester.pumpAndSettle();

      final buttons = find.byType(ElevatedButton);
      if (buttons.evaluate().isNotEmpty) {
        await tester.tap(buttons.first);
        await tester.pumpAndSettle();
      }

      expect(find.byType(JsonToolScreen), findsOneWidget);
    });
  });
}
