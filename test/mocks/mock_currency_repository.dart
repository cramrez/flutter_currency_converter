import 'package:flutter_currency_converter/src/extensions/list_extension.dart';
import 'package:flutter_currency_converter/src/model/currency.dart';
import 'package:flutter_currency_converter/src/repository/currency_repository.dart';

class MockCurrencyRepository extends CurrencyRepositoryBase {
  late List<Currency> _currencies;
  late Currency _selected;

  MockCurrencyRepository() {
    final timestamp = 500;
    final eur = Currency('EUR', 'Euro', 1, timestamp);
    final cny = Currency('CNY', 'China', 7.71, timestamp);
    final usd = Currency('USD', 'USA', 1.17, timestamp);
    final mxn = Currency('JPY', 'Japan', 129.16, timestamp);
    final jpy = Currency('MXN', 'Mexico', 24.33, timestamp);
    _selected = eur;
    _currencies = [eur, cny, usd, mxn, jpy];
  }

  Future<void> _setEnabled(String key, bool isEnabled, {int position = -1}) async {
    final result = _currencies.firstWhere((it) => it.key == key);
    final currency = Currency(
      result.key,
      result.name,
      result.value,
      result.timestamp,
      position: position,
      isEnabled: isEnabled,
    );
    _currencies.replaceWhere((it) => it.key == key, currency);
  }

  @override
  Future<void> disableCurrency(String key) => _setEnabled(key, false);

  @override
  Future<void> enableCurrency(String key, int position) => _setEnabled(key, true, position: position);

  @override
  Stream<List<Currency>> getCurrencies() async* {
    yield _currencies;
  }

  @override
  Future<Currency> getCurrency(String key) async => _currencies.firstWhere((it) => it.key == key);

  @override
  Future<int> getEnabledCurrencyCount() async => _currencies.where((it) => it.isEnabled).length;

  @override
  Future<Currency> getSelectedCurrency() async => _selected;

  @override
  Future<void> setSelectedCurrency(String key) async {
    _selected = await getCurrency(key);
  }
}
