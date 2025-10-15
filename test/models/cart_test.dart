import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Cart Model', () {
    late Cart cart;
    late Sandwich sandwich1;
    late Sandwich sandwich2;

    setUp(() {
      cart = Cart();
      sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
    });

    test('cart starts empty', () {
      expect(cart.isEmpty, true);
      expect(cart.length, 0);
      expect(cart.countOfItems, 0);
    });

    test('add method adds sandwich to cart', () {
      cart.add(sandwich1);

      expect(cart.isEmpty, false);
      expect(cart.length, 1);
      expect(cart.countOfItems, 1);
      expect(cart.getQuantity(sandwich1), 1);
    });

    test('add method can add multiple quantities at once', () {
      cart.add(sandwich1, quantity: 3);

      expect(cart.countOfItems, 3);
      expect(cart.getQuantity(sandwich1), 3);
    });

    test('add method increments quantity for same sandwich', () {
      cart.add(sandwich1);
      cart.add(sandwich1);

      expect(cart.countOfItems, 2);
      expect(cart.getQuantity(sandwich1), 2);
    });

    test('remove method decrements quantity', () {
      cart.add(sandwich1, quantity: 3);
      cart.remove(sandwich1);

      expect(cart.countOfItems, 2);
      expect(cart.getQuantity(sandwich1), 2);
    });

    test('remove method removes sandwich when quantity reaches zero', () {
      cart.add(sandwich1);
      cart.remove(sandwich1);

      expect(cart.isEmpty, true);
      expect(cart.getQuantity(sandwich1), 0);
    });

    test('clear removes all items from cart', () {
      cart.add(sandwich1);
      cart.add(sandwich2);
      cart.clear();

      expect(cart.isEmpty, true);
      expect(cart.countOfItems, 0);
    });

    test('totalPrice calculates correct price for footlong', () {
      cart.add(sandwich1); // footlong = £11

      expect(cart.totalPrice, 11.0);
    });

    test('totalPrice calculates correct price for six-inch', () {
      cart.add(sandwich2); // six-inch = £7

      expect(cart.totalPrice, 7.0);
    });

    test('totalPrice calculates correct price for multiple items', () {
      cart.add(sandwich1, quantity: 2); // 2 footlongs = £22
      cart.add(sandwich2); // 1 six-inch = £7

      expect(cart.totalPrice, 29.0);
    });

    test('getQuantity returns 0 for sandwich not in cart', () {
      expect(cart.getQuantity(sandwich1), 0);
    });
  });
}
