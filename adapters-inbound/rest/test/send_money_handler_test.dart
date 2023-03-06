import 'package:application/application.dart';
import 'package:domain/domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:adapters_inbound_rest/src/send_money_handler.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class MockSendMoneyUseCase extends Mock implements SendMoneyUseCase {}

void main() {
  late HttpServer server;

  final sendMoneyUseCase = MockSendMoneyUseCase();
  final command = SendMoneyCommand(AccountId(41), AccountId(42), Money.of(500));
  when(() => sendMoneyUseCase.sendMoney(command)).thenReturn(true);

  setUp(() async {
    final router = SendMoneyHandler(sendMoneyUseCase).getRouter();
    // final cascade = Cascade().add(router);
    server = await shelf_io.serve(router, InternetAddress.anyIPv4, 8080);
    // sleep(Duration(seconds: 1));
  });

  test('Send Money', () async {
    // When
    var url = Uri.http('localhost:8080', 'accounts/send/41/42/500');
    var response =
        await http.post(url, body: {'name': 'doodle', 'color': 'blue'});

    // Then
    expect(response.statusCode, 200);

    // And
    verify(() => sendMoneyUseCase.sendMoney(command)).called(1);
  });

  tearDown(() async {
    await server.close(force: true);
  });
}
