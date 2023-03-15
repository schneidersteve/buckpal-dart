import 'package:application/application.dart';
import 'package:domain/src/ar/account.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import 'account_mapper.dart';
import 'account_repository.dart';
import 'activity_repository.dart';

class AccountPersistenceAdapter
    implements LoadAccountPort, UpdateAccountStatePort {
  late AccountRepository accountRepository;
  late ActivityRepository activityRepository;
  late AccountMapper accountMapper;

  final logger = Logger('AccountPersistenceAdapter');

  AccountPersistenceAdapter() {
    this.accountRepository = GetIt.I.get<AccountRepository>();
    this.activityRepository = GetIt.I.get<ActivityRepository>();
    this.accountMapper = GetIt.I.get<AccountMapper>();

    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  @override
  Future<Account> loadAccount(
      AccountId accountId, DateTime baselineDate) async {
    var account = await accountRepository.findById(accountId.value);
    logger.fine("findById(id = $accountId) = ${account.id}");

    var activities = await activityRepository
        .findByOwnerAccountIdEqualsAndTimestampGreaterThanEquals(
            accountId.value, baselineDate)
        .toList();
    logger.fine(
        "findByOwnerAccountIdEqualsAndTimestampGreaterThanEquals(ownerAccountId = $accountId, timestamp = $baselineDate) = $activities");

    var withdrawalBalance = await activityRepository.getWithdrawalBalanceUntil(
        accountId.value, baselineDate);
    logger.fine(
        "getWithdrawalBalanceUntil(accountId = $accountId, until = $baselineDate) = $withdrawalBalance");

    var depositBalance = await activityRepository.getDepositBalanceUntil(
        accountId.value, baselineDate);
    logger.fine(
        "getDepositBalanceUntil(accountId = $accountId, until = $baselineDate) = $depositBalance");

    return accountMapper.mapToAccount(
        account, activities, withdrawalBalance, depositBalance);
  }

  @override
  void updateActivities(Account account) async {
    for (var activity in account.activityWindow.activities) {
      var ae = accountMapper.mapToActivityEntity(activity);
      logger.fine("save(entity = ${ae?.amount})");
      activityRepository.save(ae!);
    }
  }
}
