import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/cart_screen.dart';

void main() {
  testWidgets('CartScreen shows empty state when cart has no items',
      (WidgetTester tester) async {
    final cart = Cart();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: cart,
          child: const CartScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Empty-cart UI
    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(
        find.textContaining('Add some delicious sandwiches'), findsOneWidget);

    // When empty, there should be no total or proceed button rendered
    expect(find.textContaining('Total:'), findsNothing);
    expect(find.text('Proceed to Checkout'), findsNothing);
  });

  testWidgets('CartScreen shows item, price and total for one item',
      (WidgetTester tester) async {
    final cart = Cart();
    final sandwich = Sandwich(
      type: SandwichType.veggieDelight,
      isFootlong: true,
      breadType: BreadType.white,
    );

    // add one item
    cart.add(sandwich, quantity: 1);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: cart,
          child: const CartScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Item name and per-item price shown
    expect(find.text(sandwich.name), findsOneWidget);
    expect(find.textContaining('Price: £'), findsWidgets);

    // The UI uses 8.99 per item in cart_screen.dart
    final expectedPerItem = (8.99 * 1).toStringAsFixed(2);
    expect(find.textContaining('£$expectedPerItem'), findsWidgets);

    // Total displayed at bottom should equal per-item total
    final expectedTotal = (8.99 * 1).toStringAsFixed(2);
    expect(find.text('Total: £$expectedTotal'), findsOneWidget);

    // Proceed button exists when cart not empty
    expect(find.text('Proceed to Checkout'), findsOneWidget);
  });

  testWidgets('Tapping + increases quantity and updates total',
      (WidgetTester tester) async {
    final cart = Cart();
    final sandwich = Sandwich(
      type: SandwichType.veggieDelight,
      isFootlong: true,
      breadType: BreadType.white,
    );

    // start with 1
    cart.add(sandwich, quantity: 1);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: cart,
          child: const CartScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Tap the add icon (Icons.add_circle)
    final addIcon = find.byIcon(Icons.add_circle).first;
    expect(addIcon, findsOneWidget);
    await tester.tap(addIcon);
    await tester.pumpAndSettle();

    // Quantity should update to 2
    expect(find.text('2'), findsWidgets);

    // Total should update accordingly (8.99 * 2)
    final expectedTotal = (8.99 * 2).toStringAsFixed(2);
    expect(find.text('Total: £$expectedTotal'), findsOneWidget);
  });
}
