import 'sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class Cart {
  final Map<Sandwich, int> _items = {};

  // Returns a read-only copy of the items and their quantities
  Map<Sandwich, int> get items => Map.unmodifiable(_items);

  // Set the quantity for a sandwich (adds if not present). If quantity <= 0 the item is removed.
  void setQuantity(Sandwich sandwich, int quantity) {
    if (quantity <= 0) {
      _items.remove(sandwich);
    } else {
      _items[sandwich] = quantity;
    }
  }

  // Convenience: remove an item entirely
  void removeItem(Sandwich sandwich) {
    _items.remove(sandwich);
  }

  void add(Sandwich sandwich, {int quantity = 1}) {
    final current = _items[sandwich] ?? 0;
    _items[sandwich] = current + quantity;
  }

  void remove(Sandwich sandwich, {int quantity = 1}) {
    if (_items.containsKey(sandwich)) {
      final currentQty = _items[sandwich]!;
      if (currentQty > quantity) {
        _items[sandwich] = currentQty - quantity;
      } else {
        _items.remove(sandwich);
      }
    }
  }

  void clear() {
    _items.clear();
  }

  double get totalPrice {
    final pricingRepository = PricingRepository();
    double total = 0.0;
    for (Sandwich sandwich in _items.keys) {
      int quantity = _items[sandwich]!;
      total += pricingRepository.calculatePrice(
        quantity: quantity,
        isFootlong: sandwich.isFootlong,
      );
    }
    return total;
  }

  bool get isEmpty => _items.isEmpty;

  int get length => _items.length;

  int get countOfItems {
    int total = 0;
    for (Sandwich sandwich in _items.keys) {
      total += _items[sandwich]!;
    }
    return total;
  }

  int getQuantity(Sandwich sandwich) {
    if (_items.containsKey(sandwich)) {
      return _items[sandwich]!;
    }
    return 0;
  }
}
