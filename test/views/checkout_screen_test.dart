import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  testWidgets(
      'CheckoutScreen displays order summary with correct items and total',
      (WidgetTester tester) async {
    final Cart cart = Cart();
    final Sandwich sandwich1 = Sandwich(
      type: SandwichType.veggieDelight,
      isFootlong: true,
      breadType: BreadType.white,
    );
    final Sandwich sandwich2 = Sandwich(
      type: SandwichType.veggieDelight,
      isFootlong: false,
      breadType: BreadType.brown,
    );

    // Add items to cart
    cart.add(sandwich1, quantity: 2);
    cart.add(sandwich2, quantity: 1);

    await tester.pumpWidget(MaterialApp(home: CheckoutScreen(cart: cart)));

    // Check screen title
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.text('Order Summary'), findsOneWidget);

    // Check item listings
    expect(find.text('2x ${sandwich1.name}'), findsOneWidget);
    expect(find.text('1x ${sandwich2.name}'), findsOneWidget);

    // Compute expected prices
    final repo = PricingRepository();
    final item1Price =
        repo.calculatePrice(quantity: 2, isFootlong: sandwich1.isFootlong);
    final item2Price =
        repo.calculatePrice(quantity: 1, isFootlong: sandwich2.isFootlong);
    final totalPrice = item1Price + item2Price;

    // Check prices are displayed correctly
    expect(find.text('£${item1Price.toStringAsFixed(2)}'), findsOneWidget);
    expect(find.text('£${item2Price.toStringAsFixed(2)}'), findsOneWidget);
    expect(find.text('£${totalPrice.toStringAsFixed(2)}'), findsOneWidget);

    // Check payment method display
    expect(find.text('Payment Method: Card ending in 1234'), findsOneWidget);

    // Check confirm payment button is present
    expect(find.text('Confirm Payment'), findsOneWidget);
  });

  testWidgets('CheckoutScreen shows loading state during payment processing',
      (WidgetTester tester) async {
    final Cart cart = Cart();
    final Sandwich sandwich = Sandwich(
      type: SandwichType.veggieDelight,
      isFootlong: true,
      breadType: BreadType.white,
    );
    cart.add(sandwich, quantity: 1);

    await tester.pumpWidget(MaterialApp(home: CheckoutScreen(cart: cart)));

    // Tap confirm payment button
    await tester.tap(find.text('Confirm Payment'));
    await tester.pump(); // Start processing

    // Check loading state is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Processing payment...'), findsOneWidget);

    // Confirm payment button should be hidden during processing
    expect(find.text('Confirm Payment'), findsNothing);

    // Complete the timer to avoid pending timer error
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  testWidgets('CheckoutScreen completes payment and returns order confirmation',
      (WidgetTester tester) async {
    final Cart cart = Cart();
    final Sandwich sandwich = Sandwich(
      type: SandwichType.veggieDelight,
      isFootlong: true,
      breadType: BreadType.white,
    );
    cart.add(sandwich, quantity: 2);

    Map? orderConfirmation;

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push<Map>(
              context,
              MaterialPageRoute(builder: (_) => CheckoutScreen(cart: cart)),
            );
            orderConfirmation = result;
          },
          child: const Text('Go to Checkout'),
        ),
      ),
    ));

    // Navigate to checkout
    await tester.tap(find.text('Go to Checkout'));
    await tester.pumpAndSettle();

    // Tap confirm payment
    await tester.tap(find.text('Confirm Payment'));
    await tester.pump(); // Start processing

    // Wait for payment processing to complete (2 second delay)
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Check that we returned to the previous screen and got order confirmation
    expect(
        find.text('Go to Checkout'), findsOneWidget); // Back on original screen
    expect(orderConfirmation, isNotNull);
    expect(orderConfirmation!['orderId'], isA<String>());
    expect(orderConfirmation!['orderId'].startsWith('ORD'), true);
    expect(orderConfirmation!['totalAmount'], cart.totalPrice);
    expect(orderConfirmation!['itemCount'], cart.countOfItems);
    expect(orderConfirmation!['estimatedTime'], '15-20 minutes');
  });

  testWidgets('CheckoutScreen handles empty cart gracefully',
      (WidgetTester tester) async {
    final Cart cart = Cart(); // Empty cart

    await tester.pumpWidget(MaterialApp(home: CheckoutScreen(cart: cart)));

    // Should still show basic UI elements
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.text('Order Summary'), findsOneWidget);
    expect(find.text('Total:'), findsOneWidget);
    expect(find.text('£0.00'), findsOneWidget);
    expect(find.text('Confirm Payment'), findsOneWidget);
  });
}
