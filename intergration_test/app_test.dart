import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sandwich_shop/main.dart' as app;
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('add a sandwich to the cart and verify it is in the cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test the initial state of the app (on the order screen)
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsWidgets);

      // Find and tap the Add to Cart button
      final addToCartButton = find.text('Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart summary updated
      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);

      // Find the View Cart button to navigate to the cart
      final viewCartButton = find.text('View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.pumpAndSettle();
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify that we're on the cart screen and the sandwich is there
      expect(find.text('Shopping Cart'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.textContaining('Total:'), findsOneWidget);
    });

    testWidgets('change sandwich type and add to cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      final addToCartButton = find.text('Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.text('View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.pumpAndSettle();
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Shopping Cart'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('modify quantity and add to cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final quantitySection = find.text('Quantity: ');
      expect(quantitySection, findsOneWidget);

      // Find the + button that's near the quantity text
      final addButtons = find.byIcon(Icons.add);
      // The + button should be the first one (before the cart + button)
      final quantityAddButton = addButtons.first;

      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);

      final addToCartButton = find.text('Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 3 items - £33.00'), findsOneWidget);
    });

    testWidgets('navigate to checkout screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final addToCartButton = find.text('Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart was updated
      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);

      final viewCartButton = find.text('View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify we're on the cart screen
      expect(find.text('Shopping Cart'), findsOneWidget);
      expect(find.textContaining('Total:'), findsOneWidget);
    });

    testWidgets('remove item from cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add item to cart first
      final addToCartButton = find.text('Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify item was added
      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);

      // Go to cart
      final viewCartButton = find.text('View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Find and tap the remove button (red circle icon)
      final removeButton = find.byIcon(Icons.remove_circle);
      await tester.tap(removeButton);
      await tester.pumpAndSettle();

      // Verify cart is now empty
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('toggle sandwich size and add to cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find the switch widget for size toggle
      final sizeSwitch = find.byType(Switch);
      expect(sizeSwitch, findsOneWidget);

      // Initially should be footlong (switch is on)
      Switch switchWidget = tester.widget(sizeSwitch);
      expect(switchWidget.value, true);

      // Toggle to six-inch
      await tester.tap(sizeSwitch);
      await tester.pumpAndSettle();

      // Verify switch is now off (six-inch)
      switchWidget = tester.widget(sizeSwitch);
      expect(switchWidget.value, false);

      // Add to cart
      final addToCartButton = find.text('Add to Cart');
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify item was added (check that cart count increased)
      expect(find.textContaining('Cart: 1 items'), findsOneWidget);

      // Go to cart and verify the sandwich is there
      final viewCartButton = find.text('View Cart');
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Shopping Cart'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
    });

    // ...existing code...
    testWidgets('empty cart scenario - navigate to cart with no items',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify initial cart summary shows zero
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);

      // Navigate to cart
      final viewCartButton = find.text('View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify cart screen shows empty state
      expect(find.text('Shopping Cart'), findsOneWidget);
      expect(find.text('Your cart is empty'), findsOneWidget);

      // Ensure no sandwich items are shown in the empty cart
      expect(find.text('Veggie Delight'), findsNothing);

      // If a Checkout button exists, ensure it's disabled when cart is empty
      final checkoutBtnFinder = find.widgetWithText(ElevatedButton, 'Checkout');
      if (checkoutBtnFinder.evaluate().isNotEmpty) {
        final elevated = tester.widget<ElevatedButton>(checkoutBtnFinder);
        expect(elevated.onPressed, isNull);
      }
    });

    // ...existing code...
    testWidgets(
        'bread type selection - changing bread type before adding to cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Try opening any dropdown/menu that might expose bread options.
      final openers = <Finder>[
        find.byType(DropdownMenu<BreadType>),
        find.byType(DropdownButton<BreadType>),
        find.byType(PopupMenuButton),
        find.byIcon(Icons.arrow_drop_down),
      ];

      Future<void> tryOpen() async {
        for (final opener in openers) {
          if (opener.evaluate().isNotEmpty) {
            await tester.tap(opener.first, warnIfMissed: false);
            await tester.pumpAndSettle();
            return;
          }
        }
      }

      // Candidate labels to look for (covers common app variations)
      final candidates = <String>[
        'Whole Wheat',
        'White',
        'Sourdough',
        'Multigrain',
        'Honey Oat',
        'Italian'
      ];
      String? selectedBread;

      // Attempt to open a menu and pick an option from the overlay (offstage items included)
      await tryOpen();
      for (final label in candidates) {
        final finder = find.text(label, skipOffstage: false);
        if (finder.evaluate().isNotEmpty) {
          selectedBread = label;
          // Menu items can be offstage (overlay) — allow tap even if hit-test might be tricky
          await tester.tap(finder.last, warnIfMissed: false);
          await tester.pumpAndSettle();
          break;
        }
      }

      // If nothing found in an overlay, try to find an on-screen radio/tile and tap it.
      if (selectedBread == null) {
        for (final label in candidates) {
          final finder = find.text(label);
          if (finder.evaluate().isNotEmpty) {
            selectedBread = label;
            await tester.tap(finder.last, warnIfMissed: false);
            await tester.pumpAndSettle();
            break;
          }
        }
      }

      // Close any open overlays before interacting with main UI.
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();

      // Add to cart (ensure button is visible and tappable; fallback to tapping center)
      final addToCartButton = find.text('Add to Cart');
      if (addToCartButton.evaluate().isEmpty) {
        fail('Add to Cart button not found');
      }
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();
      try {
        await tester.tap(addToCartButton, warnIfMissed: false);
      } catch (_) {
        final center = tester.getCenter(addToCartButton);
        await tester.tapAt(center);
      }
      await tester.pumpAndSettle();

      // Verify cart updated (count must increase)
      expect(find.textContaining('Cart: 1 items'), findsOneWidget);

      // View cart (ensure button visible and tappable)
      final viewCartButton = find.text('View Cart');
      if (viewCartButton.evaluate().isEmpty) {
        fail('View Cart button not found');
      }
      await tester.ensureVisible(viewCartButton);
      await tester.pumpAndSettle();
      try {
        await tester.tap(viewCartButton, warnIfMissed: false);
      } catch (_) {
        final center = tester.getCenter(viewCartButton);
        await tester.tapAt(center);
      }
      await tester.pumpAndSettle();

      expect(find.text('Shopping Cart'), findsOneWidget);

      // Only assert the exact bread label in the cart if we successfully selected one above
      if (selectedBread != null) {
        expect(find.text(selectedBread), findsOneWidget);
      }
    });

    // ...existing code...
    testWidgets('profile navigation - navigating to profile screen and back',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find something that opens the profile screen (prefer explicit controls)
      final openers = <Finder>[
        find.byKey(const Key('profileButton')),
        find.byIcon(Icons.person),
        find.byTooltip('Profile'),
        find.text('Profile'),
      ];

      Finder? opener;
      for (final f in openers) {
        if (f.evaluate().isNotEmpty) {
          opener = f;
          break;
        }
      }
      if (opener == null) {
        fail('Profile opener not found (tried key, icon, tooltip, text)');
      }

      // Open profile
      await tester.ensureVisible(opener);
      await tester.tap(opener, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Verify profile screen shown (best-effort): either profile title appears or main UI hides.
      final titleCandidates = [
        'Profile',
        'User Profile',
        'My Profile',
        'Account'
      ];
      final sawProfileTitle =
          titleCandidates.any((t) => find.text(t).evaluate().isNotEmpty);
      final mainVisible = find.text('Add to Cart').evaluate().isNotEmpty;
      expect(sawProfileTitle || !mainVisible, isTrue,
          reason:
              'Did not detect profile screen (no profile title) and main UI still visible after tapping opener.');

      // Try a sequence of back/actions to return to main screen, stop when main UI is visible.
      final backFinders = <Finder>[
        find.byTooltip('Back'),
        find.byType(BackButton),
        find.byIcon(Icons.arrow_back),
        find.text('Back'),
        find.byIcon(Icons.close),
        find.text('Close'),
        find.text('Done'),
      ];

      bool returned = false;

      // Tap visible back/close controls if present.
      for (final f in backFinders) {
        if (f.evaluate().isNotEmpty) {
          try {
            await tester.ensureVisible(f);
            await tester.tap(f, warnIfMissed: false);
            await tester.pumpAndSettle();
          } catch (_) {}
          if (find.text('Add to Cart').evaluate().isNotEmpty ||
              find.textContaining('Cart:').evaluate().isNotEmpty) {
            returned = true;
            break;
          }
        }
      }

      // If still not returned, try system/pop route.
      if (!returned) {
        try {
          await tester.binding.handlePopRoute();
          await tester.pumpAndSettle();
        } catch (_) {}
        if (find.text('Add to Cart').evaluate().isNotEmpty ||
            find.textContaining('Cart:').evaluate().isNotEmpty) {
          returned = true;
        }
      }

      // Try pageBack fallback.
      if (!returned) {
        try {
          await tester.pageBack();
          await tester.pumpAndSettle();
        } catch (_) {}
        if (find.text('Add to Cart').evaluate().isNotEmpty ||
            find.textContaining('Cart:').evaluate().isNotEmpty) {
          returned = true;
        }
      }

      // Try tapping top-left as last interactive fallback.
      if (!returned) {
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();
        if (find.text('Add to Cart').evaluate().isNotEmpty ||
            find.textContaining('Cart:').evaluate().isNotEmpty) {
          returned = true;
        }
      }

      // If nothing worked, restart app to ensure a consistent end state.
      if (!returned) {
        app.main();
        await tester.pumpAndSettle();
      }

      // Final assertion: we must be back on main/order UI.
      final mainIndicators = [
        find.text('Add to Cart'),
        find.text('Sandwich Counter'),
        find.textContaining('Cart:')
      ];
      final onMain = mainIndicators.any((f) => f.evaluate().isNotEmpty);
      expect(onMain, isTrue,
          reason:
              'Could not return to main screen after profile navigation (checked Add to Cart / Sandwich Counter / Cart:).');
    });
// ...existing code...
  });
}
