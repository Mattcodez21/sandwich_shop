import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/common_widgets.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Shopping Cart',
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const EmptyStateWidget(
              title: 'Your cart is empty',
              message: 'Add some delicious sandwiches to get started!',
              icon: Icons.shopping_cart_outlined,
            );
          }

          final cartItems = cart.items.entries.toList();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final entry = cartItems[index];
                    final sandwich = entry.key;
                    final quantity = entry.value;
                    const pricePerItem =
                        8.99; // Default price since sandwich.price doesn't exist
                    final totalPrice = pricePerItem * quantity;

                    return CommonCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sandwich.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Price: £${totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  cart.remove(sandwich);
                                },
                                icon: const Icon(Icons.remove_circle,
                                    color: Colors.red),
                              ),
                              Text(
                                '$quantity',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {
                                  cart.add(sandwich);
                                },
                                icon: const Icon(Icons.add_circle,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              CommonCard(
                child: Column(
                  children: [
                    Text(
                      'Total: £${(cartItems.fold<double>(0, (sum, entry) => sum + (8.99 * entry.value))).toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    CommonButton(
                      text: 'Proceed to Checkout',
                      onPressed: cart.items.isNotEmpty
                          ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CheckoutScreen()),
                              )
                          : null,
                      icon: Icons.payment,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
