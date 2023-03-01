import '../vo/activity_window.dart';
import '../vo/money.dart';

import 'package:equatable/equatable.dart';

import 'activity.dart';

class AccountId extends Equatable {
  final int value;

  const AccountId(this.value);

  @override
  List<Object> get props => [value];
}

class Account {
  AccountId? id = null;
  Money baselineBalance;
  ActivityWindow activityWindow;

  Account._(this.id, this.baselineBalance, this.activityWindow);

  Account.withoutId(Money baselineBalance, ActivityWindow activityWindow)
      : this._(null, baselineBalance, activityWindow);

  Account.withId(
      AccountId accountId, Money baselineBalance, ActivityWindow activityWindow)
      : this._(accountId, baselineBalance, activityWindow);

  Money calculateBalance() {
    return Money.add(baselineBalance, activityWindow.calculateBalance(id!));
  }

  bool withdraw(Money money, AccountId targetAccountId) {
    if (!_mayWithdraw(money)) {
      return false;
    }
    var withdrawal = Activity(id!, id!, targetAccountId, DateTime.now(), money);
    activityWindow.addActivity(withdrawal);
    return true;
  }

  bool _mayWithdraw(Money money) {
    return Money.add(calculateBalance(), money.negate()).isPositiveOrZero();
  }

  bool deposit(Money money, AccountId sourceAccountId) {
    var deposit = Activity(id!, sourceAccountId, id!, DateTime.now(), money);
    activityWindow.addActivity(deposit);
    return true;
  }
}
