import 'package:flutter_currency_converter/src/model/currency.dart';
import 'package:flutter_currency_converter/src/provider/currency_provider.dart';
import 'package:flutter_currency_converter/src/repository/currency_repository.dart';

class CurrencyRepository extends CurrencyRepositoryBase {
  final CurrencyProvider _provider;

  CurrencyRepository(this._provider);

  @override
  Future<List<Currency>> getCurrencies() async {
    final result = await _provider.latest();

    final currencies = result.item1;
    final timestamp = result.item2;

    final symbols = await _provider.symbols();

    final currencyList = currencies.entries.map((it) {
      final name = symbols[it.key]!;
      return Currency(it.key, name, it.value, timestamp);
    }).toList();
    return currencyList;
  }
}
