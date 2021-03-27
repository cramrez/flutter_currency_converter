import 'package:flutter_currency_converter/src/database/currency_database.dart';
import 'package:flutter_currency_converter/src/model/currency.dart';
import 'package:flutter_currency_converter/src/provider/currency_provider.dart';
import 'package:flutter_currency_converter/src/repository/implementation/currency_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tuple/tuple.dart';

import 'currency_repository_test.mocks.dart';

@GenerateMocks([CurrencyProvider, CurrencyDatabase])
void main() {
  final timestamp = 1000;
  final currencyMap = {'USD': 1.0, 'MXN': 20.0};
  final symbols = {'USD': 'United States', 'MXN': 'Mexico'};

  final mxn = Currency('MXN', 'Mexico', 25.0, 500);
  final usd = Currency('USD', 'United States', 5.0, 500);

  final mockProvider = MockCurrencyProvider();
  final mockDatabase = MockCurrencyDatabase();

  setUpAll(() {
    when(mockDatabase.insert(any)).thenAnswer((_) async => 1);
    when(mockProvider.latest()).thenAnswer((_) async => Tuple2(currencyMap, timestamp));
    when(mockProvider.symbols()).thenAnswer((_) async => symbols);
    when(mockDatabase.getCurrencies()).thenAnswer((_) async => [usd, mxn]);
  });

  /// TODO DELETE THIS TEST BECAUSE IT REALLY CANNOT BE DONE
  test('Repository will parse the data correctly', () async {
    final repo = CurrencyRepository(mockProvider, mockDatabase);

    repo.getCurrencies().listen(expectAsync1((currencies) {
          expect(currencies.length, 2);
          expect(currencies[0].key, 'USD');
          expect(currencies[0].value, 5.0);
          expect(currencies[0].timestamp, 500);
          expect(currencies[0].name, 'United States');

          expect(currencies[1].key, 'MXN');
          expect(currencies[1].value, 25.0);
          expect(currencies[1].timestamp, 500);
          expect(currencies[1].name, 'Mexico');
        }, count: 2));
  });
}
