// Fake Repository
class AccountRepository {
  Future<AccountEntity> findById(int accountId) async {
    return AccountEntity(accountId);
  }
}

class AccountEntity {
  int? id;

  AccountEntity(this.id);
}
