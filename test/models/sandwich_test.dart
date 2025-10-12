import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich Model', () {
    test('creates a Sandwich with correct properties', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.wheat,
      );

      expect(sandwich.type, SandwichType.veggieDelight);
      expect(sandwich.isFootlong, true);
      expect(sandwich.breadType, BreadType.wheat);
    });

    test('name getter returns correct name for veggieDelight', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );

      expect(sandwich.name, 'Veggie Delight');
    });

    test('name getter returns correct name for chickenTeriyaki', () {
      final sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.white,
      );

      expect(sandwich.name, 'Chicken Teriyaki');
    });

    test('name getter returns correct name for tunaMelt', () {
      final sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );

      expect(sandwich.name, 'Tuna Melt');
    });

    test('name getter returns correct name for meatballMarinara', () {
      final sandwich = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: false,
        breadType: BreadType.white,
      );

      expect(sandwich.name, 'Meatball Marinara');
    });

    test('image getter returns correct path for footlong sandwich', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );

      expect(sandwich.image, 'assets/images/veggieDelight_footlong.png');
    });

    test('image getter returns correct path for six-inch sandwich', () {
      final sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );

      expect(sandwich.image, 'assets/images/chickenTeriyaki_six_inch.png');
    });

    test('different bread types work correctly', () {
      final whiteBread = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.white,
      );

      final wheatBread = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wheat,
      );

      final wholemealBread = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );

      expect(whiteBread.breadType, BreadType.white);
      expect(wheatBread.breadType, BreadType.wheat);
      expect(wholemealBread.breadType, BreadType.wholemeal);
    });
  });
}
