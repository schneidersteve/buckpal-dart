import 'package:adapters_inbound_rest/src/account_repository.dart';
import 'package:adapters_inbound_rest/src/activity_repository.dart';
import 'package:domain/src/ar/account.dart';
import 'package:domain/src/ar/activity.dart';

// Fake Mapper
class AccountMapper {
  Account? mapToAccount(AccountEntity account, List<ActivityEntity> activities,
      int withdrawalBalance, int depositBalance) {
    return null;
  }

  ActivityEntity? mapToActivityEntity(Activity activity) {
    return null;
  }
}
