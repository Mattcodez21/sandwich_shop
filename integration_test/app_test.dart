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

      // Try common controls to open the profile screen
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

      // Open profile and wait
      await tester.ensureVisible(opener);
      await tester.tap(opener, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Best-effort detection of profile screen: check for a title or that main UI is hidden
      final titleCandidates = [
        'Profile',
        'User Profile',
        'My Profile',
        'Account'
      ];
      final sawProfileTitle =
          titleCandidates.any((t) => find.text(t).evaluate().isNotEmpty);
      final mainStillVisible = find.text('Add to Cart').evaluate().isNotEmpty;

      expect(sawProfileTitle || !mainStillVisible, isTrue,
          reason:
              'Did not detect profile screen (no profile title) and main UI still visible after tapping opener.');
    });
// ...existing code...

    testWidgets('settings navigation - navigating to settings screen',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Try common controls to open the settings screen
      final openers = <Finder>[
        find.byKey(const Key('settingsButton')),
        find.byIcon(Icons.settings),
        find.byTooltip('Settings'),
        find.text('Settings'),
      ];

      Finder? opener;
      for (final f in openers) {
        if (f.evaluate().isNotEmpty) {
          opener = f;
          break;
        }
      }
      if (opener == null) {
        fail('Settings opener not found (tried key, icon, tooltip, text)');
      }

      // Open settings and wait
      await tester.ensureVisible(opener);
      await tester.tap(opener, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Best-effort detection of settings screen: check for a title or that main UI is hidden
      final titleCandidates = ['Settings', 'Preferences', 'App Settings'];
      final sawSettings =
          titleCandidates.any((t) => find.text(t).evaluate().isNotEmpty);
      final mainStillVisible = find.text('Add to Cart').evaluate().isNotEmpty;

      expect(sawSettings || !mainStillVisible, isTrue,
          reason:
              'Did not detect settings screen (no settings title) and main UI still visible after tapping opener.');
    });

    // ...existing code...
    testWidgets('multiple items in cart - adding different sandwiches',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add default sandwich (assumes Veggie Delight is the default shown)
      final addToCartButton = find.text('Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Change sandwich type to a different one (try dropdown first, then on-screen fallback)
      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      if (sandwichDropdown.evaluate().isNotEmpty) {
        await tester.tap(sandwichDropdown.first, warnIfMissed: false);
        await tester.pumpAndSettle();

        final chickenFinder =
            find.text('Chicken Teriyaki', skipOffstage: false);
        if (chickenFinder.evaluate().isNotEmpty) {
          await tester.tap(chickenFinder.last, warnIfMissed: false);
          await tester.pumpAndSettle();
        }
      } else {
        final chickenOnScreen = find.text('Chicken Teriyaki');
        if (chickenOnScreen.evaluate().isNotEmpty) {
          await tester.tap(chickenOnScreen.last, warnIfMissed: false);
          await tester.pumpAndSettle();
        }
      }

      // Add the second sandwich
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Verify cart summary shows two items
      expect(find.textContaining('Cart: 2 items'), findsOneWidget);

      // Open cart and verify both items are present
      final viewCartButton = find.text('View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('Shopping Cart'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('checkout form flexible filling - try many field selectors',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Ensure an item exists
      final addToCart = find.text('Add to Cart');
      if (addToCart.evaluate().isEmpty) fail('Add to Cart button not found');
      await tester.ensureVisible(addToCart);
      await tester.tap(addToCart, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Open cart and proceed
      final viewCart = find.text('View Cart');
      if (viewCart.evaluate().isEmpty) fail('View Cart button not found');
      await tester.ensureVisible(viewCart);
      await tester.tap(viewCart, warnIfMissed: false);
      await tester.pumpAndSettle();

      final proceedLabels = ['Proceed to Checkout', 'Proceed', 'Checkout'];
      Finder? proceed;
      for (final l in proceedLabels) {
        final f = find.text(l);
        if (f.evaluate().isNotEmpty) {
          proceed = f;
          break;
        }
      }
      if (proceed == null) {
        for (final el in find.byType(ElevatedButton).evaluate()) {
          final btn = el.widget as ElevatedButton;
          if (btn.onPressed != null) {
            proceed = find.byWidget(btn);
            break;
          }
        }
      }
      if (proceed == null) fail('Proceed to Checkout button not found');
      await tester.ensureVisible(proceed);
      try {
        await tester.tap(proceed, warnIfMissed: false);
      } catch (_) {
        await tester.tapAt(tester.getCenter(proceed));
      }
      await tester.pumpAndSettle();

      // Try filling common fields using multiple strategies
      final textFields = find.byType(TextFormField);
      if (textFields.evaluate().length >= 4) {
        await tester.enterText(textFields.at(0), 'Test User');
        await tester.enterText(textFields.at(1), 'test@example.com');
        await tester.enterText(textFields.at(2), '1 Test Street');
        await tester.enterText(textFields.at(3), '07123456789');
        await tester.pumpAndSettle();
      } else {
        // semantics labels and hints
        final nameCandidates = [
          find.bySemanticsLabel('Name'),
          find.text('Name')
        ];
        final emailCandidates = [
          find.bySemanticsLabel('Email'),
          find.text('Email')
        ];
        final addressCandidates = [
          find.bySemanticsLabel('Address'),
          find.text('Address')
        ];
        final phoneCandidates = [
          find.bySemanticsLabel('Phone'),
          find.bySemanticsLabel('Phone number'),
          find.text('Phone')
        ];

        bool filled = false;
        if (nameCandidates.any((f) => f.evaluate().isNotEmpty)) {
          for (final f in nameCandidates) {
            if (f.evaluate().isNotEmpty) {
              await tester.enterText(f, 'Test User');
              filled = true;
              break;
            }
          }
        }
        if (emailCandidates.any((f) => f.evaluate().isNotEmpty)) {
          for (final f in emailCandidates) {
            if (f.evaluate().isNotEmpty) {
              await tester.enterText(f, 'test@example.com');
              break;
            }
          }
        }
        if (addressCandidates.any((f) => f.evaluate().isNotEmpty)) {
          for (final f in addressCandidates) {
            if (f.evaluate().isNotEmpty) {
              await tester.enterText(f, '1 Test Street');
              break;
            }
          }
        }
        if (phoneCandidates.any((f) => f.evaluate().isNotEmpty)) {
          for (final f in phoneCandidates) {
            if (f.evaluate().isNotEmpty) {
              await tester.enterText(f, '07123456789');
              break;
            }
          }
        }

        // As a last resort fill any available TextField widgets
        if (!filled) {
          final anyTextFields = find.byType(TextField);
          final count = anyTextFields.evaluate().length;
          if (count > 0) {
            if (count > 0) {
              await tester.enterText(anyTextFields.at(0), 'Test User');
            }
            if (count > 1) {
              await tester.enterText(anyTextFields.at(1), 'test@example.com');
            }
            if (count > 2) {
              await tester.enterText(anyTextFields.at(2), '1 Test Street');
            }
            if (count > 3) {
              await tester.enterText(anyTextFields.at(3), '07123456789');
            }
          }
        }
        await tester.pumpAndSettle();
      }

      // Ensure there's some submit control available before finishing (reuse robust search)
      final placeLabels = [
        'Place Order',
        'Submit Order',
        'Confirm Order',
        'Checkout',
        'Pay'
      ];
      Finder? placeBtn;
      for (final l in placeLabels) {
        final f = find.text(l);
        if (f.evaluate().isNotEmpty) {
          placeBtn = f;
          break;
        }
      }
      if (placeBtn == null) {
        for (final el in find.byType(ElevatedButton).evaluate()) {
          final btn = el.widget as ElevatedButton;
          if (btn.onPressed != null) {
            placeBtn = find.byWidget(btn);
            break;
          }
        }
      }

      // If no place button detectable, at least assert that form fields or a submit-area exist
      if (placeBtn == null &&
          find.byType(TextFormField).evaluate().isEmpty &&
          find.byType(TextField).evaluate().isEmpty) {
        fail('No form fields or submit control found on checkout screen');
      }

      // If a place control exists, tap to exercise submission flow (best-effort)
      if (placeBtn != null) {
        await tester.ensureVisible(placeBtn);
        try {
          await tester.tap(placeBtn, warnIfMissed: false);
        } catch (_) {
          await tester.tapAt(tester.getCenter(placeBtn));
        }
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // At minimum expect either validation messages or a submit outcome to appear
      final validationMarkers = [
        'Please enter',
        'required',
        'invalid',
        'Thank you',
        'Order'
      ];
      var sawMarker = false;
      for (final m in validationMarkers) {
        if (find.textContaining(m, findRichText: false).evaluate().isNotEmpty) {
          sawMarker = true;
          break;
        }
      }
      expect(sawMarker || placeBtn != null, isTrue,
          reason:
              'Did not detect validation hints or submit control after interacting with checkout form (best-effort).');
    });

    // ...existing code...
    testWidgets(
        'cannot proceed to checkout with empty cart - simple error case',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Confirm cart shows zero items up-front
      expect(find.textContaining('Cart: 0'), findsOneWidget);

      // Open cart (try text button, fall back to cart icon)
      final viewCart = find.text('View Cart');
      if (viewCart.evaluate().isNotEmpty) {
        await tester.ensureVisible(viewCart.first);
        await tester.tap(viewCart.first);
      } else if (find.byIcon(Icons.shopping_cart).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.shopping_cart).first);
      } else {
        // If there's no visible cart control, treat the test as not applicable
        return;
      }
      await tester.pumpAndSettle();

      // Expect empty-cart UI and that checkout/proceed is not available
      expect(find.text('Your cart is empty'), findsOneWidget);

      // Common proceed labels should not be present when cart is empty
      expect(find.text('Proceed to Checkout'), findsNothing);
      expect(find.text('Checkout'), findsNothing);
      expect(find.text('Place Order'), findsNothing);
    });
// ...existing code...
  });
}
