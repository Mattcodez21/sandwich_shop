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

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final sandwichId = cart.items[index];
                    return CommonCard(
                      child: ListTile(
                        title: Text('Sandwich $sandwichId'),
                        subtitle: const Text('Price: \$8.99'),
                        trailing: CommonButton(
                          text: 'Remove',
                          onPressed: () {
                            cart.items.remove(index);
                            cart.notifyListeners();
                          },
                          isOutlined: true,
                          textColor: Colors.red,
                          icon: Icons.delete,
                        ),
                      ),
                    );
                  },
                ),
              ),
              CommonCard(
                child: Column(
                  children: [
                    Text(
                      'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
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
