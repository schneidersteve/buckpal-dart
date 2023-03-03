import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';

// ------------------------------
// Command-Query Separation (CQS)
// ------------------------------

abstract class SendMoneyUseCase {
  bool sendMoney(SendMoneyCommand command);
}

// TODO implement reflection free validating
class SendMoneyCommand extends Equatable {
  final AccountId sourceAccountId;
  final AccountId targetAccountId;
  final Money money;

  const SendMoneyCommand(
      this.sourceAccountId, this.targetAccountId, this.money);

  @override
  List<Object> get props => [sourceAccountId, targetAccountId, money];
}
