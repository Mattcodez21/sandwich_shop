import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/common_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Settings',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CommonCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Push Notifications'),
                    subtitle: const Text('Receive order updates'),
                    value: true,
                    onChanged: (value) {
                      // ...existing notification logic...
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Email Notifications'),
                    subtitle: const Text('Receive promotional emails'),
                    value: false,
                    onChanged: (value) {
                      // ...existing email logic...
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CommonCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'App Preferences',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Dark Mode'),
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {
                        // ...existing dark mode logic...
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Language'),
                    subtitle: const Text('English'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // ...existing language selection...
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CommonButton(
              text: 'Save Settings',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings saved successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: Icons.save,
            ),
            const SizedBox(height: 8),
            CommonButton(
              text: 'Reset to Defaults',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Reset Settings'),
                    content: const Text(
                        'Are you sure you want to reset all settings to default?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // ...existing reset logic...
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                );
              },
              isOutlined: true,
              icon: Icons.restore,
            ),
          ],
        ),
      ),
    );
  }
}
