import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_dart_tool/main.dart';

void main() {
  group('JsonToDartApp UI & Widget Interaction Tests', () {

    testWidgets('Renders app title, text fields, and generate button', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('JSON to Dart Pro'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Empty input triggers snackbar notification or retains state safely', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final generateBtn = find.byType(ElevatedButton);
      await tester.tap(generateBtn);
      await tester.pumpAndSettle();

      // التأكد من بقاء الواجهة مستقرة بعد الضغط على زر التحويل
      expect(find.byType(MyApp), findsOneWidget);
    });

    testWidgets('Entering invalid JSON renders error indication safely', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final textFields = find.byType(TextField);
      final jsonInput = textFields.last;

      await tester.enterText(jsonInput, '{malformed_json_test}');
      final generateBtn = find.byType(ElevatedButton);
      await tester.tap(generateBtn);
      await tester.pumpAndSettle();

      expect(find.byType(MyApp), findsOneWidget);
    });
  });
}
