// Fake Repository
class ActivityRepository {
  bool isSaved = false;

  Stream<ActivityEntity>
      findByOwnerAccountIdEqualsAndTimestampGreaterThanEquals(
          int ownerAccountId, DateTime timestamp) async* {}

  Future<int> getWithdrawalBalanceUntil(int accountId, DateTime until) async {
    switch (accountId) {
      case 1:
        return isSaved ? 2000 : 1500;
      case 2:
        return 2000;
    }
    return -1;
  }

  Future<int> getDepositBalanceUntil(int accountId, DateTime until) async {
    switch (accountId) {
      case 1:
        return 2000;
      case 2:
        return isSaved ? 2000 : 1500;
    }
    return -1;
  }

  Future<void> save(ActivityEntity ae) async {
    isSaved = true;
  }
}

class ActivityEntity {
  int? id;
  DateTime timestamp;
  int ownerAccountId;
  int sourceAccountId;
  int targetAccountId;
  int amount;

  ActivityEntity(this.id, this.timestamp, this.ownerAccountId,
      this.sourceAccountId, this.targetAccountId, this.amount);
}
