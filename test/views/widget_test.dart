import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Scroll down to see the quantity controls
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();

    // Verify that our counter starts at 1.
    expect(find.text('1'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that our counter has incremented.
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('Switch toggles between six-inch and footlong',
      (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const App());

    // Scroll down to see the switch
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -200));
    await tester.pumpAndSettle();

    // Find the sandwich size switch
    final sandwichSwitch = find.byType(Switch);

    // Verify we can find it
    expect(sandwichSwitch, findsWidgets);

    // Get the first switch widget and verify it's initially on (footlong)
    Switch switchWidget = tester.widget<Switch>(sandwichSwitch.first);
    expect(switchWidget.value, isTrue);

    // Tap the switch to toggle it
    await tester.tap(sandwichSwitch.first);
    await tester.pumpAndSettle();

    // Verify it toggled to false
    switchWidget = tester.widget<Switch>(sandwichSwitch.first);
    expect(switchWidget.value, isFalse);

    // Tap again to toggle back
    await tester.tap(sandwichSwitch.first);
    await tester.pumpAndSettle();

    // Verify it toggled back to true
    switchWidget = tester.widget<Switch>(sandwichSwitch.first);
    expect(switchWidget.value, isTrue);
  });

  group('Cart Summary Tests', () {
    testWidgets('Cart summary shows correct initial values',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll down to see the cart summary
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      expect(find.text('Items: 0'), findsOneWidget);
      expect(find.text('Total: £0.00'), findsOneWidget);
    });

    testWidgets('Cart summary updates when item is added',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll down to see the Add to Cart button
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      final addButton = find.text('Add to Cart');
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(find.text('Items: 1'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);
    });

    testWidgets('Cart summary updates with multiple items',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll down to see the buttons
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      final increaseButton = find.byIcon(Icons.add);
      await tester.tap(increaseButton);
      await tester.pumpAndSettle();

      final addButton = find.text('Add to Cart');
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(find.text('Items: 2'), findsOneWidget);
      expect(find.text('Total: £22.00'), findsOneWidget);
    });

    testWidgets('SnackBar appears when item added',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll down to see the Add to Cart button
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      final addButton = find.text('Add to Cart');
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Added'), findsOneWidget);
    });
  });
}
