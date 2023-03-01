import 'package:domain/src/vo/money.dart';
import 'package:test/test.dart';

void main() {
  test('of', () {
    var money = Money.of(42);
    expect(money.amount, BigInt.from(42));
  });

  test('add', () {
    var a = Money.of(1);
    var b = Money.of(2);
    expect(Money.add(a, b).amount, BigInt.from(3));
  });

  test('isPositiveOrZero', () {
    var minus = Money.of(-1);
    expect(minus.isPositiveOrZero(), false);

    var zero = Money.of(0);
    expect(zero.isPositiveOrZero(), true);

    var one = Money.of(1);
    expect(one.isPositiveOrZero(), true);
  });

  test('isGreaterThanOrEqualTo', () {
    var minus_two = Money.of(-2);
    var minus_one = Money.of(-1);
    var zero = Money.of(0);
    var one = Money.of(1);
    var two = Money.of(2);

    expect(minus_one.isGreaterThanOrEqualTo(minus_two), true);
    expect(zero.isGreaterThanOrEqualTo(minus_one), true);
    expect(one.isGreaterThanOrEqualTo(minus_one), true);
    expect(one.isGreaterThanOrEqualTo(zero), true);
    expect(two.isGreaterThanOrEqualTo(one), true);

    expect(minus_one.isGreaterThanOrEqualTo(minus_one), true);
    expect(zero.isGreaterThanOrEqualTo(zero), true);
    expect(one.isGreaterThanOrEqualTo(one), true);

    expect(minus_two.isGreaterThanOrEqualTo(minus_one), false);
    expect(minus_one.isGreaterThanOrEqualTo(zero), false);
    expect(zero.isGreaterThanOrEqualTo(one), false);
    expect(one.isGreaterThanOrEqualTo(two), false);
  });

  test('plus', () {
    var a = Money.of(1);
    var b = Money.of(2);
    expect(a.plus(b).amount, BigInt.from(3));
  });

  test('negate', () {
    var money = Money.of(1);
    var money_negated = Money.of(-1);
    expect(money.negate() == money_negated, true);
  });
}
