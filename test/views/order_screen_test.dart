import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/order_screen.dart';

void main() {
  testWidgets(
      'OrderScreen: adjust quantity, add to cart updates summary and shows snackbar',
      (WidgetTester tester) async {
    // pump the OrderScreen inside a MaterialApp to provide ScaffoldMessenger
    await tester.pumpWidget(const MaterialApp(home: OrderScreen()));

    // initial cart summary should report 0 items
    expect(
      find.byWidgetPredicate((w) =>
          w is Text && w.data != null && w.data!.startsWith('Cart: 0 items')),
      findsOneWidget,
    );

    // increment quantity twice (1 -> 3)
    final Finder qtyAdd = find.byIcon(Icons.add).first;
    await tester.tap(qtyAdd);
    await tester.pumpAndSettle();
    await tester.tap(qtyAdd);
    await tester.pumpAndSettle();

    // quantity label should show 3
    expect(find.text('3'), findsOneWidget);

    // tap "Add to Cart"
    await tester.tap(find.text('Add to Cart'));
    await tester.pump(); // start SnackBar animation
    await tester.pump(const Duration(seconds: 2)); // allow SnackBar duration

    // SnackBar should be shown
    expect(find.byType(SnackBar), findsOneWidget);

    // cart summary should now report 3 items
    expect(
      find.byWidgetPredicate((w) =>
          w is Text && w.data != null && w.data!.startsWith('Cart: 3 items')),
      findsOneWidget,
    );
  });
}
