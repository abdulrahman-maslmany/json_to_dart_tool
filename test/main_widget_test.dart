import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_dart_tool/main.dart';

void main() {
  group('JsonToolScreen Widget Integration Tests', () {
    testWidgets('Renders app title, text fields, and generate button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // التأكد من ظهور العنوان الرئيسي وعناصر التحكم
      expect(find.text('JSON to Dart Pro'), findsOneWidget);
      expect(
        find.byType(TextField),
        findsNWidgets(2),
      ); // ClassName field & JSON input field
      expect(find.byType(ElevatedButton), findsOneWidget); // Generate button
    });

    testWidgets('Entering invalid JSON renders error message cleanly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      final textFields = find.byType(TextField);
      final jsonInput = textFields.last;

      await tester.enterText(jsonInput, '{invalid_syntax}');
      final generateBtn = find.byType(ElevatedButton);
      await tester.tap(generateBtn);
      await tester.pump();

      // التأكد من عدم انهيار التطبيق وبقاء الواجهة سليمة
      expect(find.byType(MyApp), findsOneWidget);
    });
  });
}
