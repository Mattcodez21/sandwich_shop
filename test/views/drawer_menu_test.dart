import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/drawer_menu.dart';

void main() {
  group('DrawerMenu Widget Tests', () {
    testWidgets('should display all menu items', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DrawerMenu(currentRoute: '/'),
        ),
      );

      // Check if all menu items are present
      expect(find.text('Order'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);

      // Check if proper icons are displayed
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('should display drawer header with branding',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DrawerMenu(currentRoute: '/'),
        ),
      );

      // Check if drawer header content is displayed
      expect(find.text('Sandwich Shop'), findsOneWidget);
      expect(find.text('Delicious sandwiches made fresh'), findsOneWidget);
      expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
      expect(find.byType(DrawerHeader), findsOneWidget);
    });

    testWidgets('should highlight current route', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DrawerMenu(currentRoute: '/profile'),
        ),
      );

      // Find the Profile ListTile and check if it's selected
      final profileTile = tester.widget<ListTile>(
        find.ancestor(
          of: find.text('Profile'),
          matching: find.byType(ListTile),
        ),
      );

      expect(profileTile.selected, isTrue);
    });

    testWidgets('should display divider', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DrawerMenu(currentRoute: '/'),
        ),
      );

      // Check if divider is present
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('should have ListView structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DrawerMenu(currentRoute: '/'),
        ),
      );

      // Check basic structure
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(3));
    });
  });
}
