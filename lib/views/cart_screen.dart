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
              // iterate over a snapshot to allow removing items safely
              for (MapEntry<Sandwich, int> entry
                  in widget.cart.items.entries.toList())
                Column(
                  children: [
                    Text(entry.key.name, style: heading2),
                    Text(
                      '${_getSizeText(entry.key.isFootlong)} on ${entry.key.breadType.name} bread',
                      style: normalText,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            final sandwich = entry.key;
                            final name = sandwich.name;
                            setState(() {
                              final current = widget.cart.items[sandwich] ?? 1;
                              final next = current - 1;
                              if (next < 1) {
                                widget.cart.items.remove(sandwich);
                              } else {
                                widget.cart.items[sandwich] = next;
                              }
                            });
                            final currentAfter = widget.cart.items[sandwich];
                            if (currentAfter == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('$name removed from cart')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Updated $name quantity: $currentAfter')),
                              );
                            }
                          },
                        ),
                        Text(
                          '${entry.value}',
                          style: normalText,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            final sandwich = entry.key;
                            final name = sandwich.name;
                            setState(() {
                              final current = widget.cart.items[sandwich] ?? 0;
                              widget.cart.items[sandwich] =
                                  (current + 1).clamp(1, 999);
                            });
                            final updated = widget.cart.items[sandwich] ?? 0;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Updated $name quantity: $updated')),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        // explicit remove button
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            final sandwich = entry.key;
                            final name = sandwich.name;
                            setState(() {
                              widget.cart.items.remove(sandwich);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('$name removed from cart')),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '- £${_getItemPrice(entry.key, entry.value).toStringAsFixed(2)}',
                          style: normalText,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
