import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    test('calculates correct price for six-inch sandwich', () {
      final repository = PricingRepository();
      expect(repository.calculatePrice(quantity: 1, isFootlong: false), 7.0);
    });

    test('calculates correct price for footlong sandwich', () {
      final repository = PricingRepository();
      expect(repository.calculatePrice(quantity: 1, isFootlong: true), 11.0);
    });

    test('calculates correct price for multiple six-inch sandwiches', () {
      final repository = PricingRepository();
      expect(repository.calculatePrice(quantity: 3, isFootlong: false), 21.0);
    });

    test('calculates correct price for multiple footlong sandwiches', () {
      final repository = PricingRepository();
      expect(repository.calculatePrice(quantity: 2, isFootlong: true), 22.0);
    });

    test('returns 0 for zero quantity', () {
      final repository = PricingRepository();
      expect(repository.calculatePrice(quantity: 0, isFootlong: true), 0.0);
      expect(repository.calculatePrice(quantity: 0, isFootlong: false), 0.0);
    });
  });
}
