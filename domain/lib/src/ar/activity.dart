import 'account.dart';
import '../vo/money.dart';

import 'package:equatable/equatable.dart';

class ActivityId extends Equatable {
  final int value;

  const ActivityId(this.value);

  @override
  List<Object> get props => [value];
}

class Activity {
  ActivityId? id;
  AccountId ownerAccountId;
  AccountId sourceAccountId;
  AccountId targetAccountId;
  DateTime timestamp;
  Money money;

  /// # Arguments
  ///
  /// * `owner_account_id` - The account that owns this activity.
  /// * `source_account_id` - The debited account.
  /// * `target_account_id` - The credited account.
  /// * `timestamp` - The timestamp of the activity.
  /// * `money` - The money that was transferred between the accounts.
  Activity(AccountId ownerAccountId, AccountId sourceAccountId,
      AccountId targetAccountId, DateTime timestamp, Money money)
      : this.withId(null, ownerAccountId, sourceAccountId, targetAccountId,
            timestamp, money);

  Activity.withId(this.id, this.ownerAccountId, this.sourceAccountId,
      this.targetAccountId, this.timestamp, this.money);
}
