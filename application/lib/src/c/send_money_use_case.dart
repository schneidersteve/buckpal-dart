import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

import '../inbound_ports.dart';
import '../outbound_ports.dart';

class SendMoneyUseCaseImpl implements SendMoneyUseCase {
  late LoadAccountPort _loadAccountPort;
  late AccountLock _accountLock;
  late UpdateAccountStatePort _updateAccountStatePort;
  late MoneyTransferProperties _moneyTransferProperties;

  SendMoneyUseCaseImpl() {
    this._loadAccountPort = GetIt.I.get<LoadAccountPort>();
    this._accountLock = GetIt.I.get<AccountLock>();
    this._updateAccountStatePort = GetIt.I.get<UpdateAccountStatePort>();
    this._moneyTransferProperties = GetIt.I.get<MoneyTransferProperties>();
  }

  @override
  Future<bool> sendMoney(SendMoneyCommand command) async {
    _checkThreshold(command);

    var baselineDate = DateTime.now().subtract(const Duration(days: 10));

    var sourceAccount = await _loadAccountPort.loadAccount(
        command.sourceAccountId, baselineDate);

    var targetAccount = await _loadAccountPort.loadAccount(
        command.targetAccountId, baselineDate);

    var sourceAccountId = sourceAccount.id;
    if (sourceAccountId == null)
      throw ArgumentError("expected source account ID not to be empty");
    var targetAccountId = targetAccount.id;
    if (targetAccountId == null)
      throw ArgumentError("expected target account ID not to be empty");

    _accountLock.lockAccount(sourceAccountId);
    if (!sourceAccount.withdraw(command.money, targetAccountId)) {
      _accountLock.releaseAccount(sourceAccountId);
      return false;
    }

    _accountLock.lockAccount(targetAccountId);
    if (!targetAccount.deposit(command.money, sourceAccountId)) {
      _accountLock.releaseAccount(sourceAccountId);
      _accountLock.releaseAccount(targetAccountId);
      return false;
    }

    _updateAccountStatePort.updateActivities(sourceAccount);
    _updateAccountStatePort.updateActivities(targetAccount);

    _accountLock.releaseAccount(sourceAccountId);
    _accountLock.releaseAccount(targetAccountId);
    return true;
  }

  void _checkThreshold(SendMoneyCommand command) {
    if (command.money
        .isGreaterThan(_moneyTransferProperties.maximumTransferThreshold)) {
      throw ThresholdExceededException(
          _moneyTransferProperties.maximumTransferThreshold, command.money);
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
