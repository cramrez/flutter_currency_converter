import 'package:flutter_currency_converter/src/provider/currency_provider.dart';
import 'package:flutter_currency_converter/src/repository/implementation/currency_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tuple/tuple.dart';

import 'currency_repository_test.mocks.dart';

@GenerateMocks([CurrencyProvider])
void main() {
  final timestamp = 12345;
  final currencyMap = {'USD': 100.0, 'MXN': 0.005};
  final symbols = {'USD': 'United States', 'MXN': 'Mexico'};

  final mockProvider = MockCurrencyProvider();

  test('Repository will parse the data correctly', () async {
    when(mockProvider.latest()).thenAnswer((_) async => Tuple2(currencyMap, timestamp));
    when(mockProvider.symbols()).thenAnswer((_) async => symbols);

    final repo = CurrencyRepository(mockProvider);

    final currencies = await repo.getCurrencies();

    expect(currencies.length, 2);
    expect(currencies[0].key, 'USD');
    expect(currencies[0].value, 100.0);
    expect(currencies[0].timestamp, 12345);
    expect(currencies[0].name, 'United States');

    expect(currencies[1].key, 'MXN');
    expect(currencies[1].value, 0.005);
    expect(currencies[1].timestamp, 12345);
    expect(currencies[1].name, 'Mexico');
  });
}
