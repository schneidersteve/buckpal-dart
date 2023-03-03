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

/**
 * An account that holds a certain amount of money. An [Account] object only
 * contains a window of the latest account activities. The total balance of the account is
 * the sum of a baseline balance that was valid before the first activity in the
 * window and the sum of the activity values.
 */
class Account {
  AccountId? id = null;
  Money baselineBalance;
  ActivityWindow activityWindow;

  /// # Arguments
  ///
  /// * `id` - The unique ID of the account.
  /// * `baseline_balance` - The baseline balance of the account. This was the balance of the account before the first activity in the activityWindow.
  /// * `activity_window` - The window of latest activities on this account.
  Account._(this.id, this.baselineBalance, this.activityWindow);

  Account.withoutId(Money baselineBalance, ActivityWindow activityWindow)
      : this._(null, baselineBalance, activityWindow);

  Account.withId(
      AccountId accountId, Money baselineBalance, ActivityWindow activityWindow)
      : this._(accountId, baselineBalance, activityWindow);

  /**
     * Calculates the total balance of the account by adding the activity values to the baseline balance.
     */
  Money calculateBalance() {
    return Money.add(baselineBalance, activityWindow.calculateBalance(id!));
  }

  /**
     * Tries to withdraw a certain amount of money from this account.
     * If successful, creates a new activity with a negative value.
     * @return true if the withdrawal was successful, false if not.
     */
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

  /**
     * Tries to deposit a certain amount of money to this account.
     * If sucessful, creates a new activity with a positive value.
     * @return true if the deposit was successful, false if not.
     */
  bool deposit(Money money, AccountId sourceAccountId) {
    var deposit = Activity(id!, sourceAccountId, id!, DateTime.now(), money);
    activityWindow.addActivity(deposit);
    return true;
  }
}
