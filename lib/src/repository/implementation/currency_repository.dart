import 'package:flutter_currency_converter/src/database/currency_database.dart';
import 'package:flutter_currency_converter/src/model/currency.dart';
import 'package:flutter_currency_converter/src/provider/currency_provider.dart';
import 'package:flutter_currency_converter/src/repository/currency_repository.dart';

class CurrencyRepository extends CurrencyRepositoryBase {
  final CurrencyProvider _provider;
  final CurrencyDatabase _database;

  CurrencyRepository(this._provider, this._database);

  @override
  Stream<List<Currency>> getCurrencies() async* {
    // Return local data
    yield await _database.getCurrencies();

    // Fetch data from Api
    final result = await _provider.latest();
    final currencies = result.item1;
    final timestamp = result.item2;
    final symbols = await _provider.symbols();

    currencies.entries.forEach((it) async {
      final name = symbols[it.key]!;
      final currency = Currency(it.key, name, it.value, timestamp);

      // Update local data
      await _database.insert(currency);
    });

    // Return recently updated local data
    yield await _database.getCurrencies();
  }

  @override
  Future<void> enableCurrency(String key, int position) => _database.enableCurrency(key, position);

  @override
  Future<void> disableCurrency(String key) => _database.disableCurrency(key);

  @override
  Future<int> getEnabledCurrencyCount() => _database.getEnabledCurrencyCount();

  @override
  Future<Currency> getCurrency(String key) => _database.getCurrency(key);

  @override
  Future<Currency> getSelectedCurrency() => _database.getSelectedCurrency();

  @override
  Future<void> setSelectedCurrency(String key)=>_database.setSelectedCurrency(key);
}
