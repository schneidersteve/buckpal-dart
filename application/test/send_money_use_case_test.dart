import 'dart:ffi';

import 'package:application/src/c/send_money_use_case.dart';
import 'package:application/src/inbound_ports.dart';
import 'package:application/src/outbound_ports.dart';
import 'package:domain/domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadAccountPort extends Mock implements LoadAccountPort {}

class MockAccountLock extends Mock implements AccountLock {}

class MockUpdateAccountStatePort extends Mock
    implements UpdateAccountStatePort {}

class MockAccount extends Mock implements Account {}

void main() {
  test('Transaction succeeds', () {
    final loadAccountPort = MockLoadAccountPort();
    final accountLock = MockAccountLock();
    final updateAccountStatePort = MockUpdateAccountStatePort();
    final sendMoneyUseCase = SendMoneyUseCaseImpl(
        loadAccountPort: loadAccountPort,
        accountLock: accountLock,
        updateAccountStatePort: updateAccountStatePort,
        moneyTransferProperties:
            MoneyTransferProperties(Money.of(0x7fffffffffffffff)));

    // Given a source account
    final sourceAccount = MockAccount();
    var sourceAccountId = new AccountId(41);
    when(() => sourceAccount.id).thenReturn(sourceAccountId);
    when(() => loadAccountPort.loadAccount(sourceAccountId, any()))
        .thenReturn(sourceAccount);
    // And a target account
    final targetAccount = MockAccount();
    var targetAccountId = new AccountId(42);
    when(() => targetAccount.id).thenReturn(targetAccountId);
    when(() => loadAccountPort.loadAccount(targetAccountId, any()))
        .thenReturn(targetAccount);
    // And
    var money = Money.of(500);

    // And source account withdrawal will succeed
    when(() => sourceAccount.withdraw(money, targetAccountId)).thenReturn(true);

    // And target account deposit will succeed
    when(() => targetAccount.deposit(money, sourceAccountId)).thenReturn(true);

    // When money is send
    var command =
        new SendMoneyCommand(sourceAccount.id!, targetAccount.id!, money);
    var success = sendMoneyUseCase.sendMoney(command);

    // Then send money succeeds
    expect(success, true);

    // And source account is locked
    verify(() => accountLock.lockAccount(sourceAccountId)).called(1);
    // And source account is released
    verify(() => accountLock.releaseAccount(sourceAccountId)).called(1);

    // And target account is locked
    verify(() => accountLock.lockAccount(targetAccountId)).called(1);
    // And target account is released
    verify(() => accountLock.releaseAccount(targetAccountId)).called(1);

    // And accounts have been updated
    verify(() => updateAccountStatePort.updateActivities(sourceAccount))
        .called(1);
    verify(() => updateAccountStatePort.updateActivities(targetAccount))
        .called(1);
  });

  test('Given Withdrawal Fails then Only Source Account Is Locked And Released',
      () {
    registerFallbackValue(Money.of(-1));
    registerFallbackValue(AccountId(-1));

    final loadAccountPort = MockLoadAccountPort();
    final accountLock = MockAccountLock();
    final updateAccountStatePort = MockUpdateAccountStatePort();
    final sendMoneyUseCase = SendMoneyUseCaseImpl(
        loadAccountPort: loadAccountPort,
        accountLock: accountLock,
        updateAccountStatePort: updateAccountStatePort,
        moneyTransferProperties:
            MoneyTransferProperties(Money.of(0x7fffffffffffffff)));

    // Given a source account
    final sourceAccount = MockAccount();
    var sourceAccountId = new AccountId(41);
    when(() => sourceAccount.id).thenReturn(sourceAccountId);
    when(() => loadAccountPort.loadAccount(sourceAccountId, any()))
        .thenReturn(sourceAccount);
    // And a target account
    final targetAccount = MockAccount();
    var targetAccountId = new AccountId(42);
    when(() => targetAccount.id).thenReturn(targetAccountId);
    when(() => loadAccountPort.loadAccount(targetAccountId, any()))
        .thenReturn(targetAccount);
    // And source account withdrawal will fail
    when(() => sourceAccount.withdraw(any(), any())).thenReturn(false);
    // And target account deposit will succeed
    when(() => targetAccount.deposit(any(), any())).thenReturn(true);

    // When money is send
    var command = new SendMoneyCommand(
        sourceAccount.id!, targetAccount.id!, Money.of(300));
    var success = sendMoneyUseCase.sendMoney(command);

    // Then send money failed
    expect(success, false);
    // And source account is locked
    verify(() => accountLock.lockAccount(sourceAccountId)).called(1);
    // And source account is released
    verify(() => accountLock.releaseAccount(sourceAccountId)).called(1);
    // And target account is not locked
    verifyNever(() => accountLock.lockAccount(targetAccountId));
  });
}
