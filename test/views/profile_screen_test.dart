import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/profile_screen.dart';

void main() {
  group('ProfileScreen Widget Tests', () {
    testWidgets('should display all form fields and save button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Check if the screen title is displayed
      expect(find.text('Enter Your Details'), findsOneWidget);

      // Check if all form fields are present
      expect(find.byType(TextFormField), findsNWidgets(3));

      // Check specific form fields by their labels
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);

      // Check if save button is present
      expect(find.text('Save Profile'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display proper icons for each form field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Check if proper icons are displayed
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.phone), findsOneWidget);
    });

    testWidgets(
        'should show validation errors when form is submitted with empty fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Tap the save button without entering any data
      await tester.tap(find.text('Save Profile'));
      await tester.pump();

      // Check if validation errors are displayed
      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your phone number'), findsOneWidget);
    });

    testWidgets('should show email validation error for invalid email',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).at(1), 'invalid-email');

      // Tap save button
      await tester.tap(find.text('Save Profile'));
      await tester.pump();

      // Check if email validation error is displayed
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should accept valid form data and show success message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Enter valid data in all fields
      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.enterText(
          find.byType(TextFormField).at(1), 'john.doe@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), '123-456-7890');

      // Tap save button
      await tester.tap(find.text('Save Profile'));
      await tester.pump();

      // Check if success message is displayed
      expect(find.text('Profile saved successfully!'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('should allow text input in all form fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Enter text in each field and verify it appears
      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.enterText(
          find.byType(TextFormField).at(1), 'john@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), '1234567890');

      // Check that the text was entered successfully
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
      expect(find.text('1234567890'), findsOneWidget);
    });

    testWidgets('should clear form fields when text is entered and cleared',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Enter text in name field
      await tester.enterText(find.byType(TextFormField).at(0), 'Test Name');
      expect(find.text('Test Name'), findsOneWidget);

      // Clear the field
      await tester.enterText(find.byType(TextFormField).at(0), '');
      await tester.pump();

      // Verify the field is empty
      final nameField =
          tester.widget<TextFormField>(find.byType(TextFormField).at(0));
      expect(nameField.controller?.text, isEmpty);
    });

    testWidgets('should have proper app bar with title and back button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Check if app bar is present with correct title
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('should validate that name field trims whitespace',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Enter only whitespace in name field
      await tester.enterText(find.byType(TextFormField).at(0), '   ');

      // Tap save button
      await tester.tap(find.text('Save Profile'));
      await tester.pump();

      // Check if validation error is displayed (should treat whitespace as empty)
      expect(find.text('Please enter your name'), findsOneWidget);
    });
  });
}
