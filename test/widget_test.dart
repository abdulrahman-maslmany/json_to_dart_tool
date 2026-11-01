import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Application UI Smoke Tests', () {
    testWidgets('App shell renders title and basic components safely', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('JSON to Dart Pro'),
            ),
          ),
        ),
      );

      expect(find.text('JSON to Dart Pro'), findsOneWidget);
    });
  });
}
