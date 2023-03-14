import 'package:application/application.dart';
import 'package:domain/src/ar/account.dart';
import 'package:logging/logging.dart';

import 'account_mapper.dart';
import 'account_repository.dart';
import 'activity_repository.dart';

class AccountPersistenceAdapter
    implements LoadAccountPort, UpdateAccountStatePort {
  AccountRepository accountRepository;
  ActivityRepository activityRepository;
  AccountMapper accountMapper;

  final logger = Logger('AccountPersistenceAdapter');

  AccountPersistenceAdapter(
      this.accountRepository, this.activityRepository, this.accountMapper) {
    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  @override
  Account loadAccount(AccountId accountId, DateTime baselineDate) {
    var account = accountRepository.findById(accountId.value);
    logger.fine("findById(id = $accountId) = ${account.id}");

    var activities = activityRepository
        .findByOwnerAccountIdEqualsAndTimestampGreaterThanEquals(
            accountId.value, baselineDate);
    logger.fine(
        "findByOwnerAccountIdEqualsAndTimestampGreaterThanEquals(ownerAccountId = $accountId, timestamp = $baselineDate) = $activities");

    var withdrawalBalance = activityRepository.getWithdrawalBalanceUntil(
        accountId.value, baselineDate);
    logger.fine(
        "getWithdrawalBalanceUntil(accountId = $accountId, until = $baselineDate) = $withdrawalBalance");

    var depositBalance = activityRepository.getDepositBalanceUntil(
        accountId.value, baselineDate);
    logger.fine(
        "getDepositBalanceUntil(accountId = $accountId, until = $baselineDate) = $depositBalance");

    return accountMapper.mapToAccount(
        account, activities, withdrawalBalance, depositBalance);
  }

  @override
  void updateActivities(Account account) {
    for (var activity in account.activityWindow.activities) {
      var ae = accountMapper.mapToActivityEntity(activity);
      logger.fine("save(entity = ${ae?.amount})");
      activityRepository.save(ae!);
    }
  }
}
