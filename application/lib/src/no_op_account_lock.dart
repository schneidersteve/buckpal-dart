import 'package:domain/src/ar/account.dart';

import 'outbound_ports.dart';

class NoOpAccountLock extends AccountLock {
  @override
  void lockAccount(AccountId accountId) {
    // do nothing
  }

  @override
  void releaseAccount(AccountId accountId) {
    // do nothing
  }
}
