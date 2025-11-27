import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/common_widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'About Us',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CommonCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Sandwich Shop!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'We are a family-owned business dedicated to serving the best sandwiches in town. Our commitment to quality ingredients and exceptional service has made us a local favorite for over 10 years.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const CommonCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Story',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Founded in 2013, we started with a simple mission: create delicious, fresh sandwiches using only the finest ingredients.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const CommonCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Phone: (555) 123-4567\nEmail: info@sandwichshop.com\nAddress: 123 Main St, Your City',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CommonButton(
              text: 'Visit Our Website',
              onPressed: () {
                // Add URL launcher logic here
              },
              icon: Icons.web,
            ),
          ],
        ),
      ),
    );
  }
}
