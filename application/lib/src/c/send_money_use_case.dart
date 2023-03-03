import 'package:domain/domain.dart';

import '../inbound_ports.dart';
import '../outbound_ports.dart';

class SendMoneyUseCaseImpl extends SendMoneyUseCase {
  final LoadAccountPort loadAccountPort;
  final AccountLock accountLock;
  final UpdateAccountStatePort updateAccountStatePort;
  final MoneyTransferProperties moneyTransferProperties;

  SendMoneyUseCaseImpl(
      {required this.loadAccountPort,
      required this.accountLock,
      required this.updateAccountStatePort,
      required this.moneyTransferProperties});

  @override
  bool sendMoney(SendMoneyCommand command) {
    _checkThreshold(command);

    var baselineDate = DateTime.now().subtract(const Duration(days: 10));

    var sourceAccount =
        loadAccountPort.loadAccount(command.sourceAccountId, baselineDate);

    var targetAccount =
        loadAccountPort.loadAccount(command.targetAccountId, baselineDate);

    var sourceAccountId = sourceAccount.id;
    if (sourceAccountId == null)
      throw ArgumentError("expected source account ID not to be empty");
    var targetAccountId = targetAccount.id;
    if (targetAccountId == null)
      throw ArgumentError("expected target account ID not to be empty");

    accountLock.lockAccount(sourceAccountId);
    if (!sourceAccount.withdraw(command.money, targetAccountId)) {
      accountLock.releaseAccount(sourceAccountId);
      return false;
    }

    accountLock.lockAccount(targetAccountId);
    if (!targetAccount.deposit(command.money, sourceAccountId)) {
      accountLock.releaseAccount(sourceAccountId);
      accountLock.releaseAccount(targetAccountId);
      return false;
    }

    updateAccountStatePort.updateActivities(sourceAccount);
    updateAccountStatePort.updateActivities(targetAccount);

    accountLock.releaseAccount(sourceAccountId);
    accountLock.releaseAccount(targetAccountId);
    return true;
  }

  void _checkThreshold(SendMoneyCommand command) {
    if (command.money
        .isGreaterThan(moneyTransferProperties.maximumTransferThreshold)) {
      throw ThresholdExceededException(
          moneyTransferProperties.maximumTransferThreshold, command.money);
    }
  }
}

class MoneyTransferProperties {
  Money maximumTransferThreshold = Money.of(1000000);

  MoneyTransferProperties(this.maximumTransferThreshold);
}

class ThresholdExceededException implements Exception {
  Money threshold;
  Money actual;

  ThresholdExceededException(this.threshold, this.actual);

  String wdExpMsg() =>
      "Maximum threshold for transferring money exceeded: tried to transfer " +
      actual.toString() +
      " but threshold is " +
      threshold.toString() +
      "!";
}
