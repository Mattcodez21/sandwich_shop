import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Sandwich Counter')),
        body: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OrderItemDisplay(3, 'BLT'),
            OrderItemDisplay(5, 'Club'),
            OrderItemDisplay(2, 'Veggie'),
          ],
        ),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final String itemType;
  final int quantity;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        height: 200,
        color: Colors.blue,
        alignment: Alignment.center,
        child: Text('$quantity $itemType sandwich(es): ${'🥪' * quantity}'));
  }
}
