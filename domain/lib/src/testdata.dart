import 'ar/account.dart';
import 'ar/activity.dart';
import 'vo/activity_window.dart';
import 'vo/money.dart';

AccountBuilder defaultAccount() {
  return AccountBuilder()
      .withAccountId(AccountId(42))
      .withBaselineBalance(Money.of(999))
      .withActivityWindow(ActivityWindow(
          [defaultActivity().build(), defaultActivity().build()]));
}

class AccountBuilder {
  AccountId? accountId = null;
  Money? baselineBalance = null;
  ActivityWindow? activityWindow = null;

  AccountBuilder withAccountId(AccountId accountId) {
    this.accountId = accountId;
    return this;
  }

  AccountBuilder withBaselineBalance(Money baselineBalance) {
    this.baselineBalance = baselineBalance;
    return this;
  }

  AccountBuilder withActivityWindow(ActivityWindow activityWindow) {
    this.activityWindow = activityWindow;
    return this;
  }

  Account build() {
    return Account.withId(accountId!, baselineBalance!, activityWindow!);
  }
}

ActivityBuilder defaultActivity() {
  return ActivityBuilder()
      .withOwnerAccount(AccountId(42))
      .withSourceAccount(AccountId(42))
      .withTargetAccount(AccountId(41))
      .withTimestamp(DateTime.now())
      .withMoney(Money.of(999));
}

class ActivityBuilder {
  ActivityId? id = null;
  AccountId? ownerAccountId = null;
  AccountId? sourceAccountId = null;
  AccountId? targetAccountId = null;
  DateTime? timestamp = null;
  Money? money = null;

  ActivityBuilder withId(ActivityId? id) {
    this.id = id;
    return this;
  }

  ActivityBuilder withOwnerAccount(AccountId accountId) {
    ownerAccountId = accountId;
    return this;
  }

  ActivityBuilder withSourceAccount(AccountId accountId) {
    sourceAccountId = accountId;
    return this;
  }

  ActivityBuilder withTargetAccount(AccountId accountId) {
    targetAccountId = accountId;
    return this;
  }

  ActivityBuilder withTimestamp(DateTime timestamp) {
    this.timestamp = timestamp;
    return this;
  }

  ActivityBuilder withMoney(Money money) {
    this.money = money;
    return this;
  }

  Activity build() {
    return Activity.withId(id, ownerAccountId!, sourceAccountId!,
        targetAccountId!, timestamp!, money!);
  }
}
