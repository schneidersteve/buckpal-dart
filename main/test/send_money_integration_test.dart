import 'package:adapters_inbound_rest/rest.dart';
import 'package:adapters_outbound_persistence/persistence.dart';
import 'package:application/application.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:http/http.dart' as http;

void main() {
  late HttpServer server;

  setUp(() async {
    wireDependencies();
    final router = SendMoneyHandler().getRouter();
    // final cascade = Cascade().add(router);
    server = await shelf_io.serve(router, InternetAddress.anyIPv4, 8080);
    // sleep(Duration(seconds: 1));
  });

  test('Send Money', () async {
    final loadAccountPort = GetIt.I.get<LoadAccountPort>();

    // Given initial source account balance
    var sourceAccountId = new AccountId(1);
    var sourceAccount =
        await loadAccountPort.loadAccount(sourceAccountId, DateTime.now());
    var initialSourceBalance = sourceAccount.calculateBalance();

    // And initial target account balance
    var targetAccountId = new AccountId(2);
    var targetAccount =
        await loadAccountPort.loadAccount(targetAccountId, DateTime.now());
    var initialTargetBalance = targetAccount.calculateBalance();

    // When money is send
    var money = Money.of(500);
    var url = Uri.http('localhost:8080',
        'accounts/send/${sourceAccountId.value}/${targetAccountId.value}/${money.amount}');
    var response =
        await http.post(url, body: {'name': 'doodle', 'color': 'blue'});

    // Then http status is OK
    expect(response.statusCode, 200);

    // And source account balance is correct
    sourceAccount =
        await loadAccountPort.loadAccount(sourceAccountId, DateTime.now());
    expect(sourceAccount.calculateBalance(), initialSourceBalance.minus(money));

    // And target account balance is correct
    targetAccount =
        await loadAccountPort.loadAccount(targetAccountId, DateTime.now());

    expect(targetAccount.calculateBalance(), initialTargetBalance.plus(money));
  });

  tearDown(() async {
    await server.close(force: true);
  });
}

void wireDependencies() {
  GetIt.I.reset();

  GetIt.I.registerSingleton<AccountRepository>(AccountRepository());
  GetIt.I.registerSingleton<ActivityRepository>(ActivityRepository());
  GetIt.I.registerSingleton<AccountMapper>(AccountMapper());

  GetIt.I.registerSingleton<AccountPersistenceAdapter>(
      AccountPersistenceAdapter());
  GetIt.I.registerSingleton<LoadAccountPort>(
      GetIt.I.get<AccountPersistenceAdapter>());
  GetIt.I.registerSingleton<AccountLock>(NoOpAccountLock());
  GetIt.I.registerSingleton<MoneyTransferProperties>(
      MoneyTransferProperties(Money.of(1000)));
  GetIt.I.registerSingleton<UpdateAccountStatePort>(
      GetIt.I.get<AccountPersistenceAdapter>());

  GetIt.I.registerSingleton<SendMoneyUseCase>(SendMoneyUseCaseImpl());

  // GetIt.I.registerSingletonWithDependencies<AccountPersistenceAdapter>(
  //     () => AccountPersistenceAdapter(),
  //     dependsOn: [AccountRepository, ActivityRepository, AccountMapper]);
  // GetIt.I.registerSingletonWithDependencies<LoadAccountPort>(
  //     () => GetIt.I.get<AccountPersistenceAdapter>(),
  //     dependsOn: [AccountPersistenceAdapter]);
  // GetIt.I.registerSingletonWithDependencies<UpdateAccountStatePort>(
  //     () => GetIt.I.get<AccountPersistenceAdapter>(),
  //     dependsOn: [AccountPersistenceAdapter]);

  // final accountRepository = AccountRepository();
  // final activityRepository = ActivityRepository();
  // final accountMapper = AccountMapper();
  // final loadAccountPort = AccountPersistenceAdapter(
  //     accountRepository, activityRepository, accountMapper);

  // final accountLock = NoOpAccountLock();

  // final moneyTransferProperties = MoneyTransferProperties(Money.of(1000));

  // GetIt.I.registerSingletonWithDependencies<SendMoneyUseCase>(
  //     () => SendMoneyUseCaseImpl(),
  //     dependsOn: [
  //       LoadAccountPort,
  //       AccountLock,
  //       UpdateAccountStatePort,
  //       MoneyTransferProperties
  //     ]);

  // final sendMoneyUseCase = SendMoneyUseCaseImpl(
  //     loadAccountPort: loadAccountPort,
  //     accountLock: accountLock,
  //     updateAccountStatePort: loadAccountPort,
  //     moneyTransferProperties: moneyTransferProperties);

  // return (loadAccountPort, sendMoneyUseCase);
}
