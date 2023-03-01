import 'package:domain/src/ar/account.dart';
import 'package:domain/src/testdata.dart';
import 'package:domain/src/vo/activity_window.dart';
import 'package:domain/src/vo/money.dart';
import 'package:test/test.dart';

void main() {
  test('calculatesBalance', () {
    var accountId = AccountId(1);
    var account = defaultAccount()
        .withAccountId(accountId)
        .withBaselineBalance(Money.of(555))
        .withActivityWindow(ActivityWindow([
          defaultActivity()
              .withTargetAccount(accountId)
              .withMoney(Money.of(999))
              .build(),
          defaultActivity()
              .withTargetAccount(accountId)
              .withMoney(Money.of(1))
              .build()
        ]))
        .build();
    var balance = account.calculateBalance();
    expect(balance, Money.of(1555));
  });

  test('withdrawalSucceeds', () {
    var accountId = AccountId(1);
    var account = defaultAccount()
        .withAccountId(accountId)
        .withBaselineBalance(Money.of(555))
        .withActivityWindow(ActivityWindow([
          defaultActivity()
              .withTargetAccount(accountId)
              .withMoney(Money.of(999))
              .build(),
          defaultActivity()
              .withTargetAccount(accountId)
              .withMoney(Money.of(1))
              .build()
        ]))
        .build();
    var success = account.withdraw(Money.of(555), AccountId(99));
    expect(success, true);
    expect(account.activityWindow.activities.length, 3);
    expect(account.calculateBalance(), Money.of(1000));
  });

  test('withdrawalFailure', () {
    var accountId = AccountId(1);
    var account = defaultAccount()
        .withAccountId(accountId)
        .withBaselineBalance(Money.of(555))
        .withActivityWindow(ActivityWindow([
          defaultActivity()
              .withTargetAccount(accountId)
              .withMoney(Money.of(999))
              .build(),
          defaultActivity()
              .withTargetAccount(accountId)
              .withMoney(Money.of(1))
              .build()
        ]))
        .build();
    var success = account.withdraw(Money.of(1556), AccountId(99));
    expect(success, false);
    expect(account.activityWindow.activities.length, 2);
    expect(account.calculateBalance(), Money.of(1555));
  });

    test('depositSuccess', () {
    var accountId = AccountId(1);
    var account = defaultAccount()
        .withAccountId(accountId)
        .withBaselineBalance(Money.of(555))
        .withActivityWindow(ActivityWindow([
          defaultActivity()
              .withTargetAccount(accountId)
              .withMoney(Money.of(999))
              .build(),
          defaultActivity()
              .withTargetAccount(accountId)
              .withMoney(Money.of(1))
              .build()
        ]))
        .build();
    var success = account.deposit(Money.of(445), AccountId(99));
    expect(success, true);
    expect(account.activityWindow.activities.length, 3);
    expect(account.calculateBalance(), Money.of(2000));
  });
}
