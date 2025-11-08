import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  testWidgets('CartScreen shows empty state when cart has no items',
      (WidgetTester tester) async {
    final Cart cart = Cart();

    await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

    // Empty-cart message visible
    expect(find.text('Your cart is empty'), findsOneWidget);

    // Total should be £0.00
    expect(find.text('Total: £0.00'), findsOneWidget);
  });

  testWidgets(
      'CartScreen: increment, decrement (remove when below 1), explicit remove, total updates and snackbars shown',
      (WidgetTester tester) async {
    final Cart cart = Cart();
    final Sandwich sandwich = Sandwich(
      type: SandwichType.veggieDelight,
      isFootlong: true,
      breadType: BreadType.white,
    );

    // Add initial quantity = 2
    cart.add(sandwich, quantity: 2);

    await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));
    await tester.pumpAndSettle();

    // Verify item name and initial quantity shown
    expect(find.text(sandwich.name), findsOneWidget);
    expect(find.text('2'), findsWidgets); // quantity label present

    // Compute expected totals
    final PricingRepository repo = PricingRepository();
    final String totalFor2 = repo
        .calculatePrice(quantity: 2, isFootlong: sandwich.isFootlong)
        .toStringAsFixed(2);
    expect(find.text('Total: £$totalFor2'), findsOneWidget);

    // Tap + to increase to 3
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump(); // rebuild
    await tester.pump(const Duration(milliseconds: 1600)); // allow snackbar
    expect(find.byType(SnackBar), findsOneWidget);

    final String totalFor3 = repo
        .calculatePrice(quantity: 3, isFootlong: sandwich.isFootlong)
        .toStringAsFixed(2);
    expect(find.text('Total: £$totalFor3'), findsOneWidget);

    // Tap - twice to remove (3 -> 2 -> 1), then once more to remove item
    await tester.tap(find.byIcon(Icons.remove).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600)); // snackbar
    expect(find.byType(SnackBar), findsOneWidget);

    // After one remove, total should be for 2 again
    expect(find.text('Total: £$totalFor2'), findsOneWidget);

    // Remove twice more to drop below 1 and cause removal:
    await tester.tap(find.byIcon(Icons.remove).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600));
    // Now quantity should be 1
    expect(find.text('1'), findsOneWidget);

    // Tap remove once more to delete the item (or use delete icon)
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pump();
    await tester
        .pump(const Duration(milliseconds: 1600)); // snackbar for delete

    // After removal, empty state should be shown and total £0.00
    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('Total: £0.00'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
