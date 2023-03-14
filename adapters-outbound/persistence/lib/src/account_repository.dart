// Fake Repository
class AccountRepository {
  AccountEntity findById(int accountId) {
    return AccountEntity(accountId);
  }
}

class AccountEntity {
  int? id;

  AccountEntity(this.id);
}
