import 'package:adapters_inbound_rest/rest.dart';
import 'package:adapters_outbound_persistence/persistence.dart';
import 'package:application/application.dart';
import 'package:domain/domain.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:http/http.dart' as http;

void main() {
  late HttpServer server;

  final deps = wireDependencies();

  setUp(() async {
    final router = SendMoneyHandler(deps.$2).getRouter();
    // final cascade = Cascade().add(router);
    server = await shelf_io.serve(router, InternetAddress.anyIPv4, 8080);
    // sleep(Duration(seconds: 1));
  });

  test('Send Money', () async {
    // Given initial source account balance
    var sourceAccountId = new AccountId(1);
    var sourceAccount =
        deps.$1.loadAccount(sourceAccountId, DateTime.now());
    var initialSourceBalance = sourceAccount.calculateBalance();

    // And initial target account balance
    var targetAccountId = new AccountId(2);
    var targetAccount =
        deps.$1.loadAccount(targetAccountId, DateTime.now());
    var initialTargetBalance = targetAccount.calculateBalance();

    // When money is send
    var money = Money.of(500);
    var url = Uri.http('localhost:8080', 'accounts/send/${sourceAccountId.value}/${targetAccountId.value}/${money.amount}');
    var response =
        await http.post(url, body: {'name': 'doodle', 'color': 'blue'});

    // Then http status is OK
    expect(response.statusCode, 200);

    // And source account balance is correct
    sourceAccount =
        deps.$1.loadAccount(sourceAccountId, DateTime.now());
    expect(sourceAccount.calculateBalance(), initialSourceBalance.minus(money));

    // And target account balance is correct
    targetAccount =
        deps.$1.loadAccount(targetAccountId, DateTime.now());

    expect(targetAccount.calculateBalance(), initialTargetBalance.plus(money));

  });

  tearDown(() async {
    await server.close(force: true);
  });
}

(AccountPersistenceAdapter, SendMoneyUseCaseImpl) wireDependencies() {
  final accountRepository = AccountRepository();
  final activityRepository = ActivityRepository();
  final accountMapper = AccountMapper();
  final loadAccountPort = AccountPersistenceAdapter(
      accountRepository, activityRepository, accountMapper);

  final accountLock = NoOpAccountLock();

  final moneyTransferProperties = MoneyTransferProperties(Money.of(1000));

  final sendMoneyUseCase = SendMoneyUseCaseImpl(
      loadAccountPort: loadAccountPort,
      accountLock: accountLock,
      updateAccountStatePort: loadAccountPort,
      moneyTransferProperties: moneyTransferProperties);

  return (loadAccountPort, sendMoneyUseCase);
}
