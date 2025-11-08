import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  void _goBack() {
    Navigator.pop(context);
  }

  void _showFeedback(String message) {
    // clear any existing snackbars and show a short floating one
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1400),
      ),
    );
  }

  String _getSizeText(bool isFootlong) {
    if (isFootlong) {
      return 'Footlong';
    } else {
      return 'Six-inch';
    }
  }

  double _getItemPrice(Sandwich sandwich, int quantity) {
    final PricingRepository pricingRepository = PricingRepository();
    return pricingRepository.calculatePrice(
      quantity: quantity,
      isFootlong: sandwich.isFootlong,
    );
  }

  double _calculateTotalPrice() {
    double total = 0.0;
    for (final entry in widget.cart.items.entries) {
      total += _getItemPrice(entry.key, entry.value);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: const Text(
          'Cart View',
          style: heading1,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // show a clear empty-cart message if there are no items
              if (widget.cart.items.isEmpty) ...[
                const Icon(Icons.shopping_cart_outlined,
                    size: 72, color: Colors.grey),
                const SizedBox(height: 12),
                const Text(
                  'Your cart is empty',
                  style: heading2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add items from the Order screen to get started.',
                  style: normalText,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
              // iterate over a snapshot to allow removing items safely
              for (MapEntry<Sandwich, int> entry
                  in widget.cart.items.entries.toList())
                Column(
                  children: [
                    // capture the sandwich and fetch the current quantity from the map
                    Builder(builder: (context) {
                      final sandwich = entry.key;
                      final name = sandwich.name;
                      final currentQty = widget.cart.items[sandwich] ?? 0;
                      final itemPrice = _getItemPrice(sandwich, currentQty);
                      return Column(
                        children: [
                          Text(sandwich.name, style: heading2),
                          Text(
                            '${_getSizeText(sandwich.isFootlong)} on ${sandwich.breadType.name} bread',
                            style: normalText,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    final current =
                                        widget.cart.items[sandwich] ?? 1;
                                    final next = current - 1;
                                    if (next < 1) {
                                      widget.cart.items.remove(sandwich);
                                    } else {
                                      widget.cart.items[sandwich] = next;
                                    }
                                  });
                                  final after = widget.cart.items[sandwich];
                                  if (after == null) {
                                    _showFeedback('$name removed from cart');
                                  } else {
                                    _showFeedback(
                                        'Updated $name quantity: $after');
                                  }
                                },
                              ),
                              // read fresh quantity from the map so UI is always current
                              Text(
                                '${widget.cart.items[sandwich] ?? 0}',
                                style: normalText,
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    final current =
                                        widget.cart.items[sandwich] ?? 0;
                                    widget.cart.items[sandwich] =
                                        (current + 1).clamp(1, 999);
                                  });
                                  final updated =
                                      widget.cart.items[sandwich] ?? 0;
                                  _showFeedback(
                                      'Updated $name quantity: $updated');
                                },
                              ),
                              const SizedBox(width: 8),
                              // explicit remove button
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    widget.cart.items.remove(sandwich);
                                  });
                                  _showFeedback('$name removed from cart');
                                },
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '- £${itemPrice.toStringAsFixed(2)}',
                                style: normalText,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }),
                  ],
                ),
              Text(
                'Total: £${_calculateTotalPrice().toStringAsFixed(2)}',
                style: heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _goBack,
                icon: Icons.arrow_back,
                label: 'Back to Order',
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
