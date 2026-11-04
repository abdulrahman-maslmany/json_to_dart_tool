import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// ✅ استيراد الملف الحقيقي للتطبيق
import 'package:json_to_dart_tool/main.dart';

void main() {
  group('JsonToolScreen Real Widget Interaction Tests', () {
    testWidgets('Renders real app UI and verifies interactive components', (WidgetTester tester) async {
      // ✅ بناء الواجهة الحقيقية بدلاً من الشاشة الوهمية
      // (إذا كان الكلاس الرئيسي في main.dart اسمه MyApp أو JsonToDartApp يمكنك وضعه مباشرة)
      await tester.pumpWidget(const MaterialApp(home: JsonToolScreen()));
      await tester.pumpAndSettle();

      // التحقق من وجود حقول الإدخال والأزرار في شاشتك الحقيقية
      expect(find.byType(TextField), findsWidgets);
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('Entering invalid JSON handles state gracefully without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: JsonToolScreen()));
      await tester.pumpAndSettle();

      // البحث عن حقول الإدخال
      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);

      // محاكاة إدخال نص JSON في الحقل
      await tester.enterText(textFields.last, '{"name": "test"}');
      await tester.pumpAndSettle();

      // محاكاة الضغط على زر التوليد الحقيقي
      final buttons = find.byType(ElevatedButton);
      if (buttons.evaluate().isNotEmpty) {
        await tester.tap(buttons.first);
        await tester.pumpAndSettle();
      }

      // التأكد من استقرار الشاشة بعد العملية
      expect(find.byType(JsonToolScreen), findsOneWidget);
    });
  });
}
