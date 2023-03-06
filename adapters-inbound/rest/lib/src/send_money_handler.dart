import 'package:application/application.dart';
import 'package:domain/domain.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class SendMoneyHandler {
  SendMoneyUseCase _sendMoneyUseCase;

  SendMoneyHandler(this._sendMoneyUseCase);

  Response _send_money(Request request, String sourceAccountId,
      String targetAccountId, String amount) {
    var command = SendMoneyCommand(AccountId(int.parse(sourceAccountId)),
        AccountId(int.parse(targetAccountId)), Money.of(int.parse(amount)));

    _sendMoneyUseCase.sendMoney(command);

    return Response.ok(null);
  }

  Router getRouter() {
    return Router()
      ..post(
          '/accounts/send/<sourceAccountId|[0-9]+>/<targetAccountId|[0-9]+>/<amount|[0-9]+>',
          _send_money);
  }
}
