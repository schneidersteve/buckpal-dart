// Fake Repository
class ActivityRepository {
  List<ActivityEntity> findByOwnerAccountIdEqualsAndTimestampGreaterThanEquals(
      int value, DateTime baselineDate) {
    return <ActivityEntity>[
      ActivityEntity(1, DateTime(2018, 8, 8, 8, 0, 0), 1, 1, 2, 500)
    ].toList();
  }

  int getWithdrawalBalanceUntil(int value, DateTime baselineDate) {
    return 500;
  }

  int getDepositBalanceUntil(int value, DateTime baselineDate) {
    return 400;
  }

  void save(ActivityEntity ae) {}
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
