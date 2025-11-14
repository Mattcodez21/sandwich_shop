import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  testWidgets(
      'OrderScreen: adjust quantity, add to cart updates summary and shows snackbar',
      (WidgetTester tester) async {
    // Set a larger test screen size to ensure all content is visible
    await tester.binding.setSurfaceSize(const Size(800, 1200));

    // pump the OrderScreen inside a MaterialApp to provide ScaffoldMessenger
    await tester.pumpWidget(const MaterialApp(home: OrderScreen()));

    // initial cart summary should report 0 items
    expect(
      find.byWidgetPredicate((w) =>
          w is Text && w.data != null && w.data!.startsWith('Cart: 0 items')),
      findsOneWidget,
    );

    // Find the main scrollable (SingleChildScrollView) by looking for vertical scrolling
    final mainScrollable = find.byWidgetPredicate((widget) =>
        widget is Scrollable && widget.axisDirection == AxisDirection.down);

    // Scroll down to make sure quantity controls are visible
    await tester.drag(mainScrollable, const Offset(0, -300));
    await tester.pumpAndSettle();

    // Find all + icons and get the last one (quantity +)
    final qtyAddButtons = find.byIcon(Icons.add);
    expect(qtyAddButtons, findsWidgets);

    // Get the last + button which should be the quantity one
    final Finder qtyAdd = qtyAddButtons.last;

    // increment quantity twice (1 -> 3)
    await tester.tap(qtyAdd);
    await tester.pumpAndSettle();
    await tester.tap(qtyAdd);
    await tester.pumpAndSettle();

    // quantity label should show 3
    expect(find.text('3'), findsOneWidget);

    // Scroll down more to make buttons visible
    await tester.drag(mainScrollable, const Offset(0, -200));
    await tester.pumpAndSettle();

    // tap "Add to Cart"
    await tester.tap(find.text('Add to Cart'));
    await tester.pump(); // start SnackBar animation
    await tester.pump(const Duration(seconds: 2)); // allow SnackBar duration

    // SnackBar should be shown and contain confirmation text
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.byWidgetPredicate(
          (w) => w is Text && w.data != null && w.data!.contains('Added 3')),
      findsWidgets,
    );

    // cart summary should now report 3 items
    expect(
      find.byWidgetPredicate((w) =>
          w is Text && w.data != null && w.data!.startsWith('Cart: 3 items')),
      findsOneWidget,
    );

    // Reset surface size when done
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });

  testWidgets('OrderScreen -> CartScreen navigation shows added items & total',
      (WidgetTester tester) async {
    // Set a larger test screen size
    await tester.binding.setSurfaceSize(const Size(800, 1200));

    await tester.pumpWidget(const MaterialApp(home: OrderScreen()));

    // Find the main scrollable (SingleChildScrollView)
    final mainScrollable = find.byWidgetPredicate((widget) =>
        widget is Scrollable && widget.axisDirection == AxisDirection.down);

    // Scroll down to make quantity controls visible
    await tester.drag(mainScrollable, const Offset(0, -300));
    await tester.pumpAndSettle();

    // increase quantity to 2
    final Finder qtyAdd = find.byIcon(Icons.add).last;
    await tester.tap(qtyAdd);
    await tester.pumpAndSettle();

    // Scroll down more to make buttons visible
    await tester.drag(mainScrollable, const Offset(0, -200));
    await tester.pumpAndSettle();

    // add to cart
    await tester.tap(find.text('Add to Cart'));
    await tester.pump(); // start SnackBar
    await tester.pump(const Duration(seconds: 2)); // allow SnackBar to show

    // navigate to cart
    await tester.tap(find.text('View Cart'));
    await tester.pumpAndSettle();

    // CartScreen title present
    expect(find.text('Cart View'), findsOneWidget);

    // Build the same sandwich as OrderScreen defaults to compute expected price
    final sandwich = Sandwich(
      type: SandwichType.veggieDelight,
      isFootlong: true,
      breadType: BreadType.white,
    );
    final repo = PricingRepository();
    final expectedTotal =
        repo.calculatePrice(quantity: 2, isFootlong: sandwich.isFootlong);

    // Check item name present and total price displayed
    expect(find.text(sandwich.name), findsOneWidget);
    expect(find.text('Total: £${expectedTotal.toStringAsFixed(2)}'),
        findsOneWidget);

    // Reset surface size when done
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });
}
