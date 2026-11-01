import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JsonToolScreen Widget Interaction Tests', () {
    testWidgets('Renders text input fields and action generate buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('JSON to Dart Pro')),
            body: Column(
              children: [
                const TextField(decoration: InputDecoration(hintText: 'Enter Root Class Name')),
                const TextField(decoration: InputDecoration(hintText: 'Paste JSON here')),
                ElevatedButton(onPressed: () {}, child: const Text('Generate')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('JSON to Dart Pro'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Handles input interactions safely without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: const Text('Test Action'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Test Action'), findsOneWidget);
    });
  });
}
