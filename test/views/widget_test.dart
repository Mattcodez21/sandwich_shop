// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App() as Widget);

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
  testWidgets('Switch toggles between six-inch and footlong',
      (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const App());

    // Verify initial state
    expect(find.text('footlong'), findsOneWidget);
    expect(find.text('six-inch'), findsOneWidget);

    // Find the sandwich size switch using the key
    final sandwichSwitch = find.byKey(const Key('sandwich_size_switch'));

    // Verify we can find it
    expect(sandwichSwitch, findsOneWidget);

    // Get the widget and verify it's initially on (footlong)
    Switch switchWidget = tester.widget<Switch>(sandwichSwitch);
    expect(switchWidget.value, isTrue);

    // Tap the switch to toggle it
    await tester.tap(sandwichSwitch);
    await tester.pump();

    // Verify it toggled to false
    switchWidget = tester.widget<Switch>(sandwichSwitch);
    expect(switchWidget.value, isFalse);

    // Tap again to toggle back
    await tester.tap(sandwichSwitch);
    await tester.pump();

    // Verify it toggled back to true
    switchWidget = tester.widget<Switch>(sandwichSwitch);
    expect(switchWidget.value, isTrue);

    group('Cart Summary Tests', () {
      testWidgets('Cart summary shows correct initial values',
          (WidgetTester tester) async {
        await tester.pumpWidget(const App());

        expect(find.text('Items: 0'), findsOneWidget);
        expect(find.text('Total: £0.00'), findsOneWidget);
      });

      testWidgets('Cart summary updates when item is added',
          (WidgetTester tester) async {
        await tester.pumpWidget(const App());

        final addButton = find.widgetWithText(ElevatedButton, 'Add to Cart');
        await tester.tap(addButton);
        await tester.pump();

        expect(find.text('Items: 1'), findsOneWidget);
        expect(find.text('Total: £11.00'), findsOneWidget);
      });

      testWidgets('Cart summary updates with multiple items',
          (WidgetTester tester) async {
        await tester.pumpWidget(const App());

        final increaseButton = find.byIcon(Icons.add);
        await tester.tap(increaseButton);
        await tester.pump();

        final addButton = find.widgetWithText(ElevatedButton, 'Add to Cart');
        await tester.tap(addButton);
        await tester.pump();

        expect(find.text('Items: 2'), findsOneWidget);
        expect(find.text('Total: £22.00'), findsOneWidget);
      });

      testWidgets('SnackBar appears when item added',
          (WidgetTester tester) async {
        await tester.pumpWidget(const App());

        final addButton = find.widgetWithText(ElevatedButton, 'Add to Cart');
        await tester.tap(addButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.textContaining('Added'), findsOneWidget);
      });
    });
  });
}
