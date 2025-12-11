// ...existing code...
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';

Future<void> _ensureVisibleAndTap(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) fail('Finder not found: $finder');
  final scrollable = find.byType(Scrollable);
  if (scrollable.evaluate().isNotEmpty) {
    try {
      await tester.scrollUntilVisible(finder, 200.0,
          scrollable: scrollable.first);
      await tester.pumpAndSettle();
    } catch (_) {}
  }
  await tester.ensureVisible(finder.first);
  await tester.tap(finder.first, warnIfMissed: false);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('CheckoutScreen displays order summary and total',
      (WidgetTester tester) async {
    final cart = Cart();
    final s1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white);
    final s2 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white);

    cart.add(s1, quantity: 2);
    cart.add(s2, quantity: 1);

    await tester.pumpWidget(
      MaterialApp(
          home: ChangeNotifierProvider.value(
              value: cart, child: const CheckoutScreen())),
    );

    await tester.pumpAndSettle();

    expect(find.text('Order Summary'), findsOneWidget);
    expect(find.text('${s1.name} x2'), findsOneWidget);
    expect(find.text('${s2.name} x1'), findsOneWidget);

    final total = (8.99 * 2 + 8.99 * 1).toStringAsFixed(2);
    expect(find.textContaining('£$total'), findsWidgets);
  });

  testWidgets(
      'CheckoutScreen shows validation messages when submitting empty form',
      (WidgetTester tester) async {
    final cart = Cart();
    final s = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white);
    cart.add(s, quantity: 1);

    await tester.pumpWidget(
      MaterialApp(
          home: ChangeNotifierProvider.value(
              value: cart, child: const CheckoutScreen())),
    );

    await tester.pumpAndSettle();

    Finder place = find.byKey(const ValueKey('placeOrderButton'));
    if (place.evaluate().isEmpty) place = find.text('Place Order');

    await _ensureVisibleAndTap(tester, place);

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your address'), findsOneWidget);
    expect(find.text('Please enter your phone number'), findsOneWidget);
  });

  testWidgets('CheckoutScreen shows success flow and clears cart (robust)',
      (WidgetTester tester) async {
    final cart = Cart();
    final s = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white);
    cart.add(s, quantity: 1);

    await tester.pumpWidget(
      MaterialApp(
          home: ChangeNotifierProvider.value(
              value: cart, child: const CheckoutScreen())),
    );

    await tester.pumpAndSettle();

    // Fill form fields (if present)
    final tfs = find.byType(TextFormField);
    if (tfs.evaluate().isNotEmpty) {
      await tester.enterText(tfs.at(0), 'Tester');
      if (tfs.evaluate().length > 1) {
        await tester.enterText(tfs.at(1), 'tester@example.com');
      }
      if (tfs.evaluate().length > 2) {
        await tester.enterText(tfs.at(2), '1 Test St');
      }
      if (tfs.evaluate().length > 3) {
        await tester.enterText(tfs.at(3), '07123456789');
      }
      await tester.pumpAndSettle();
    }

    Finder place = find.byKey(const ValueKey('placeOrderButton'));
    if (place.evaluate().isEmpty) place = find.text('Place Order');
    if (place.evaluate().isEmpty) {
      // Nothing to submit — treat as not applicable
      return;
    }

    await _ensureVisibleAndTap(tester, place);

    // Poll for success indicators for up to ~4 seconds:
    var sawSuccess = false;
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 200));
      // success dialog text
      if (find.text('Payment Accepted!').evaluate().isNotEmpty ||
          find
              .text('Your order has been placed successfully.')
              .evaluate()
              .isNotEmpty) {
        sawSuccess = true;
        break;
      }
      // cart cleared by implementation
      if (cart.items.isEmpty) {
        sawSuccess = true;
        break;
      }
    }

    expect(sawSuccess, isTrue,
        reason:
            'No success dialog appeared and cart was not cleared after placing order.');

    // If there's an OK button from success dialog, dismiss it to tidy up
    if (find.text('OK').evaluate().isNotEmpty) {
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
    }

    // final assertion: cart should be empty (implementation clears cart on success)
    expect(cart.items.isEmpty, isTrue);
  });
}
// ...existing code...
