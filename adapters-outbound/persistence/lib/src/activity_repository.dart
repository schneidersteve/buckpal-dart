// Fake Repository
class ActivityRepository {
  bool isSaved = false;

  List<ActivityEntity> findByOwnerAccountIdEqualsAndTimestampGreaterThanEquals(
      int ownerAccountId, DateTime timestamp) {
    return List.empty();
    // return <ActivityEntity>[
    //   ActivityEntity(1, DateTime(2018, 8, 8, 8, 0, 0), 1, 1, 2, 500)
    // ].toList();
  }

  int getWithdrawalBalanceUntil(int accountId, DateTime until) {
    switch (accountId) {
      case 1:
        return isSaved ? 2000 : 1500;
      case 2:
        return 2000;
    }
    return -1;
  }

  int getDepositBalanceUntil(int accountId, DateTime until) {
    switch (accountId) {
      case 1:
        return 2000;
      case 2:
        return isSaved ? 2000 : 1500;
    }
    return -1;
  }

  void save(ActivityEntity ae) {
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
