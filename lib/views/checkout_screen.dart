import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/common_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Checkout',
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CommonCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Summary',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        for (final entry in cart.items.entries)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${entry.key.name} x${entry.value}'),
                                Text(
                                    '£${(8.99 * entry.value).toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(
                              '£${(cart.items.entries.fold<double>(0, (sum, entry) => sum + (8.99 * entry.value))).toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
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
                          'Delivery Information',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter your name'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter your email'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: 'Delivery Address',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter your address'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter your phone number'
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  CommonButton(
                    text: 'Place Order',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _placeOrder(context, cart);
                      }
                    },
                    icon: Icons.check_circle,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ...existing code...
  // ...existing code...
  void _placeOrder(BuildContext context, Cart cart) async {
    // capture useful objects before any await
    final navigator = Navigator.of(context);
    ScaffoldMessenger.of(context);

    // show the loading dialog using the current context (before awaiting)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Processing payment...'),
            ],
          ),
        ),
      ),
    );

    // long-running async work
    await Future.delayed(const Duration(seconds: 2));

    // don't use 'context' after await; use captured objects and still check mounted
    if (!mounted) return;

    // close loading dialog
    navigator.pop();

    if (!mounted) return;

    // show success by using the captured navigator (or scaffoldMessenger)
    await showDialog(
      context: navigator.context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 50),
        title: const Text('Payment Accepted!'),
        content: const Text('Your order has been placed successfully.'),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    // clear via Cart API
    try {
      cart.clear();
    } catch (_) {}

    if (mounted) {
      navigator.popUntil((route) => route.isFirst);
    }
  }
// ...existing code...
}
