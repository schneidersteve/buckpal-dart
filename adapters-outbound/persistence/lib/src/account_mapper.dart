import 'package:domain/domain.dart';
import 'package:domain/src/ar/activity.dart';
import 'package:domain/src/vo/activity_window.dart';

import 'account_repository.dart';
import 'activity_repository.dart';

// Fake Mapper
class AccountMapper {
  Account mapToAccount(AccountEntity account, List<ActivityEntity> activities,
      int withdrawalBalance, int depositBalance) {
    var baselineBalance =
        Money.substract(Money.of(depositBalance), Money.of(withdrawalBalance));
    return Account.withId(AccountId(account.id!), baselineBalance,
        mapToActivityWindow(activities));
  }

  ActivityWindow mapToActivityWindow(List<ActivityEntity> activities) {
    return ActivityWindow(activities
        .map((ae) => Activity.withId(
            ActivityId(ae.id!),
            AccountId(ae.ownerAccountId),
            AccountId(ae.sourceAccountId),
            AccountId(ae.targetAccountId),
            ae.timestamp,
            Money.of(ae.amount)))
        .toList());
  }

  ActivityEntity? mapToActivityEntity(Activity activity) {
    return ActivityEntity(
        activity.id?.value,
        activity.timestamp,
        activity.ownerAccountId.value,
        activity.sourceAccountId.value,
        activity.targetAccountId.value,
        activity.money.amount.toInt());
  }
}
