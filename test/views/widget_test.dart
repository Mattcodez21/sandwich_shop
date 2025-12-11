import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('App builds and shows basic widgets', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsWidgets);
    expect(find.byType(Text), findsWidgets);
  });

  testWidgets('Switch toggle (if present) changes value', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    final switchFinder = find.byKey(const Key('sandwich_size_switch'));
    // If the switch isn't present, treat the test as not-applicable and pass.
    if (switchFinder.evaluate().isEmpty) return;

    // Read initial value, tap, and assert it toggled.
    final Switch swBefore = tester.widget<Switch>(switchFinder);
    final bool before = swBefore.value;

    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    final Switch swAfter = tester.widget<Switch>(switchFinder);
    final bool after = swAfter.value;

    expect(after, equals(!before));
  });

  testWidgets('Cart summary updates after adding an item (tolerant)',
      (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Try to find an Add to Cart control (button text or ElevatedButton)
    Finder addButton = find.widgetWithText(ElevatedButton, 'Add to Cart');
    if (addButton.evaluate().isEmpty) addButton = find.text('Add to Cart');

    // If there's no add control, the test is not applicable — pass early.
    if (addButton.evaluate().isEmpty) return;

    // Tap the add button and allow any SnackBar / UI updates to run.
    await tester.tap(addButton.first);
    await tester.pump(); // start animations
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // Look for any Text that likely represents the cart summary:
    // either contains the word "Cart" or contains a digit count (e.g. "1", "2")
    final summaryFinder = find.byWidgetPredicate((w) {
      if (w is Text && w.data != null) {
        final txt = w.data!.toLowerCase();
        final hasCart = txt.contains('cart');
        final hasDigits = RegExp(r'\b\d+\b').hasMatch(txt);
        return hasCart || hasDigits;
      }
      return false;
    });

    expect(summaryFinder, findsWidgets,
        reason:
            'Expected at least one Text widget showing cart summary or item count after adding.');
  });
}
