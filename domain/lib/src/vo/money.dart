import 'package:equatable/equatable.dart';

class Money extends Equatable {
  final BigInt amount;

  const Money(this.amount);

  @override
  List<Object> get props => [amount];

  static Money ZERO = Money.of(0);

  static Money of(int value) {
    return Money(BigInt.from(value));
  }

  static Money add(Money a, Money b) {
    return Money(a.amount + b.amount);
  }

  static Money substract(Money a, Money b) {
    return Money(a.amount - b.amount);
  }

  bool isPositiveOrZero() {
    return amount.compareTo(BigInt.zero) >= 0;
  }

  bool isNegative() {
    return amount.compareTo(BigInt.zero) < 0;
  }

  bool isPositive() {
    return amount.compareTo(BigInt.zero) > 0;
  }

  bool isGreaterThanOrEqualTo(Money money) {
    return amount.compareTo(money.amount) >= 0;
  }

  bool isGreaterThan(Money money) {
    return amount.compareTo(money.amount) >= 1;
  }

  Money minus(Money money) {
    return Money(this.amount - money.amount);
  }

  Money plus(Money money) {
    return Money(this.amount + money.amount);
  }

  Money negate() {
    return Money(-amount);
  }
}
