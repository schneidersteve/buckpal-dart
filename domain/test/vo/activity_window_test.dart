import 'package:domain/src/ar/account.dart';
import 'package:domain/src/testdata.dart';
import 'package:domain/src/vo/activity_window.dart';
import 'package:domain/src/vo/money.dart';
import 'package:test/test.dart';

void main() {
  test('calculatesStartTimestamp', () {
    var window = ActivityWindow([
      defaultActivity().withTimestamp(startDate()).build(),
      defaultActivity().withTimestamp(inBetweenDate()).build(),
      defaultActivity().withTimestamp(endDate()).build()
    ]);
    expect(window.getStartTimestamp(), startDate());
  });

  test('calculatesEndTimestamp', () {
    var window = ActivityWindow([
      defaultActivity().withTimestamp(startDate()).build(),
      defaultActivity().withTimestamp(inBetweenDate()).build(),
      defaultActivity().withTimestamp(endDate()).build()
    ]);
    expect(window.getEndTimestamp(), endDate());
  });

  test('calculatesBalance', () {
    var account1 = AccountId(1);
    var account2 = AccountId(2);
    var window = ActivityWindow([
        defaultActivity()
            .withSourceAccount(account1)
            .withTargetAccount(account2)
            .withMoney(Money.of(999)).build(),
        defaultActivity()
            .withSourceAccount(account1)
            .withTargetAccount(account2)
            .withMoney(Money.of(1)).build(),
        defaultActivity()
            .withSourceAccount(account2)
            .withTargetAccount(account1)
            .withMoney(Money.of(500)).build()
    ]);
    expect(window.calculateBalance(account1), Money.of(-500));
    expect(window.calculateBalance(account2), Money.of(500));
  });
}

DateTime startDate() {
  return DateTime.utc(2019, 8, 3, 0, 0);
}

DateTime inBetweenDate() {
  return DateTime.utc(2019, 8, 4, 0, 0);
}

DateTime endDate() {
  return DateTime.utc(2019, 8, 5, 0, 0);
}
