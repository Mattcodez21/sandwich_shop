// ...existing code...
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  testWidgets('OrderScreen adds items to Cart (inspect Cart directly)',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    final cart = Cart();

    // Provide Cart above MaterialApp so pushed routes can read it.
    await tester.pumpWidget(
      ChangeNotifierProvider<Cart>.value(
        value: cart,
        child: const MaterialApp(home: OrderScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Tap the last "+" once to make quantity 2, then Add to Cart.
    final adds = find.byIcon(Icons.add);
    expect(adds, findsWidgets);
    final qtyAdd = adds.last;
    await tester.ensureVisible(qtyAdd);
    await tester.tap(qtyAdd);
    await tester.pumpAndSettle();

    final addToCart = find.text('Add to Cart');
    expect(addToCart, findsOneWidget);
    await tester.ensureVisible(addToCart);
    await tester.tap(addToCart);
    await tester.pumpAndSettle();

    // Inspect Cart object directly rather than relying on UI currency formatting
    final totalQty = cart.items.values.fold<int>(0, (a, b) => a + b);
    expect(totalQty, equals(2));

    // Ensure the key in the cart is a Sandwich and matches expected default name
    final firstKey = cart.items.keys.first;
    expect(firstKey, isA<Sandwich>());
    expect((firstKey).name.toLowerCase(), contains('veggie'));
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });

  testWidgets('OrderScreen shows snackbar confirmation when adding',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    final cart = Cart();

    await tester.pumpWidget(
      ChangeNotifierProvider<Cart>.value(
        value: cart,
        child: const MaterialApp(home: OrderScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Increase to 3 (two taps)
    final qtyAdd = find.byIcon(Icons.add).last;
    await tester.ensureVisible(qtyAdd);
    await tester.tap(qtyAdd);
    await tester.pumpAndSettle();
    await tester.tap(qtyAdd);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add to Cart'));
    await tester.pump(); // start snackbar animation
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.byWidgetPredicate(
          (w) => w is Text && (w.data ?? '').toLowerCase().contains('added')),
      findsWidgets,
    );
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });
}
