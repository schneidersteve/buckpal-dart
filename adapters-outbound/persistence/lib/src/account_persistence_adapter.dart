import 'package:application/application.dart';
import 'package:domain/src/ar/account.dart';

import 'account_mapper.dart';
import 'account_repository.dart';
import 'activity_repository.dart';

class AccountPersistenceAdapter
    implements LoadAccountPort, UpdateAccountStatePort {
  AccountRepository accountRepository;
  ActivityRepository activityRepository;
  AccountMapper accountMapper;

  AccountPersistenceAdapter(
      this.accountRepository, this.activityRepository, this.accountMapper);

  @override
  Account loadAccount(AccountId accountId, DateTime baselineDate) {
    var account = accountRepository.findById(accountId.value);

    var activities = activityRepository
        .findByOwnerAccountIdEqualsAndTimestampGreaterThanEquals(
            accountId.value, baselineDate);

    var withdrawalBalance = activityRepository.getWithdrawalBalanceUntil(
        accountId.value, baselineDate);

    var depositBalance = activityRepository.getDepositBalanceUntil(
        accountId.value, baselineDate);

    return accountMapper.mapToAccount(
        account, activities, withdrawalBalance, depositBalance)!;
  }

  @override
  void updateActivities(Account account) {
    for (var activity in account.activityWindow.activities) {
      var ae = accountMapper.mapToActivityEntity(activity);
      activityRepository.save(ae!);
    }
  }
}
