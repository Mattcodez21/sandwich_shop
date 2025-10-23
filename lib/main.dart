import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;
  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  bool _isFootlong = true;

  // Controller for the order note TextField
  final TextEditingController _noteController = TextEditingController();

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String sandwichSize = _isFootlong ? 'Footlong' : 'Six-inch';

    return Scaffold(
      appBar: AppBar(title: const Text('Sandwich Counter')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              OrderItemDisplay(_quantity, sandwichSize),

              const SizedBox(height: 12),

              // keep plain counter text so existing tests that look for '0' still pass
              Text('$_quantity', style: const TextStyle(fontSize: 18)),

              const SizedBox(height: 12),

              // TextField following Flutter docs pattern
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _noteController,
                  onChanged: (value) => setState(() {}),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Order Note (e.g. "no onions")',
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Display the confirmed note on screen
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _noteController.text.isEmpty
                      ? 'No note added'
                      : 'Note: ${_noteController.text}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Six-inch'),
                  Switch(
                    value: _isFootlong,
                    onChanged: (value) => setState(() => _isFootlong = value),
                  ),
                  const Text('Footlong'),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _quantity < widget.maxQuantity
                        ? _increaseQuantity
                        : null,
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _quantity > 0 ? _decreaseQuantity : null,
                    icon: const Icon(Icons.remove),
                    label: const Text('Remove'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;
  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 160,
      color: Colors.blue,
      alignment: Alignment.center,
      child: Text(
        '$quantity $itemType sandwich(es): ${'🥪' * quantity}',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
