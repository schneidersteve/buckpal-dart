import 'package:domain/domain.dart';

abstract class LoadAccountPort {
  Account loadAccount(AccountId accountId, DateTime baselineDate);
}

abstract class AccountLock {
  void lockAccount(AccountId accountId);
  void releaseAccount(AccountId accountId);
}

abstract class UpdateAccountStatePort {
  void updateActivities(Account account);
}
