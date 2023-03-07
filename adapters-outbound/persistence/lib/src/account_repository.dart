// Fake Repository
class AccountRepository {
  AccountEntity findById(int value) {
    return AccountEntity(1);
  }
}

class AccountEntity {
  int? id;

  AccountEntity(this.id);
}
