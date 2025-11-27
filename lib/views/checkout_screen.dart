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
                        for (int i = 0; i < cart.items.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Sandwich ${cart.items[i]}'),
                                const Text('\$8.99'),
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
                              '\$${(cart.items.length * 8.99).toStringAsFixed(2)}',
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

  void _placeOrder(BuildContext context, Cart cart) {
    cart.items.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order placed successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
