import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_dart_tool/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget createTestWidget() {
    return const MaterialApp(
      home: JsonToolScreen(),
    );
  }

  group('JsonToolScreen Complete UI & Security Test Suite', () {
    testWidgets('1. Renders initial UI elements correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('JSON to Dart Pro'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Generate'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      expect(find.text('// Your Dart classes will appear here...'),
          findsOneWidget);
    });

    testWidgets('2. Empty JSON triggers EmptyInputException and SnackBar',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final generateBtn = find.widgetWithText(ElevatedButton, 'Generate');
      await tester.tap(generateBtn);
      await tester.pump();

      expect(find.text('Please paste some JSON first!'), findsOneWidget);
    });

    testWidgets('3. Valid JSON generates Dart code and triggers clipboard copy',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      final jsonField = textFields.last;

      await tester.enterText(jsonField, '{"user_id": 101, "username": "alex"}');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Generate'));
      await tester.pumpAndSettle();

      expect(find.textContaining('class MyModel'), findsOneWidget);
      expect(find.textContaining('final int userId;'), findsOneWidget);

      final copyBtn = find.byIcon(Icons.copy_all);
      expect(copyBtn, findsOneWidget);
      await tester.tap(copyBtn);
      await tester.pump();

      expect(find.text('Code copied to clipboard!'), findsOneWidget);
    });

    testWidgets('4. Custom root class name generates correctly',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      final classNameField = textFields.first;
      final jsonField = textFields.last;

      await tester.enterText(classNameField, 'ProductEntity');
      await tester.enterText(jsonField, '{"sku": "A123", "price": 99.9}');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Generate'));
      await tester.pumpAndSettle();

      expect(find.textContaining('class ProductEntity'), findsOneWidget);
      expect(find.textContaining('final double price;'), findsOneWidget);
    });

    testWidgets('5. Handles list of objects properly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final jsonField = find.byType(TextField).last;
      await tester.enterText(jsonField, '[{"title": "Book 1"}]');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Generate'));
      await tester.pumpAndSettle();

      expect(find.textContaining('class MyModel'), findsOneWidget);
      expect(find.textContaining('final String title;'), findsOneWidget);
    });

    testWidgets('6. Handles list of primitives with warning', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final jsonField = find.byType(TextField).last;
      await tester.enterText(jsonField, '[1, 2, 3]');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Generate'));
      await tester.pumpAndSettle();

      expect(
          find.textContaining(
              '// The list contains primitive values, not objects.'),
          findsOneWidget);
    });

    testWidgets('7. Handles malformed JSON syntax gracefully', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final jsonField = find.byType(TextField).last;
      await tester.enterText(jsonField, '{"broken": json');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Generate'));
      await tester.pumpAndSettle();

      expect(find.textContaining('// Error: Invalid JSON format!'),
          findsOneWidget);
    });

    testWidgets(
        '8. Handles oversized input and triggers OversizedInputException',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final jsonField = find.byType(TextField).last;
      // ✅ 100,005 حرف لتجاوز الحد الأقصى 100,000 مباشرة بدون ثقل
      final massivePayload = '{"data":"${"A" * 100005}"}';
      await tester.enterText(jsonField, massivePayload);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Generate'));
      await tester.pump();

      expect(
          find.text('JSON payload exceeds maximum safe size!'), findsOneWidget);
      expect(find.textContaining('Security Warning'), findsOneWidget);
    });

    testWidgets('9. Clear button resets text field and generated code',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final jsonField = find.byType(TextField).last;
      await tester.enterText(jsonField, '{"user_id": 101, "username": "alex"}');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Generate'));
      await tester.pumpAndSettle();

      // Tap Clear IconButton
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      final textFieldWidget = tester.widget<TextField>(jsonField);
      expect(textFieldWidget.controller?.text, isEmpty);
      expect(find.text('// Your Dart classes will appear here...'),
          findsOneWidget);
    });
  });
}
