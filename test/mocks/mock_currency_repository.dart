import 'package:flutter_currency_converter/src/extensions/list_extension.dart';
import 'package:flutter_currency_converter/src/model/currency.dart';
import 'package:flutter_currency_converter/src/repository/currency_repository.dart';

class MockCurrencyRepository extends CurrencyRepositoryBase {
  late List<Currency> _currencies;
  Currency? _selected;

  MockCurrencyRepository() {
    final _timestamp = 500;
    final _eur = Currency('EUR', 'Euro', 20, _timestamp);
    final _cny = Currency('CNY', 'China', 10, _timestamp);
    final _usd = Currency('USD', 'USA', 15, _timestamp);
    final _mxn = Currency('JPY', 'Mexico', 5, _timestamp);
    final _jpy = Currency('MXN', 'Japan', 8, _timestamp);
    _currencies = [_eur, _cny, _usd, _mxn, _jpy];
  }

  Future<void> _setEnabled(String key, bool isEnabled) async {
    final result = _currencies.firstWhere((it) => it.key == key);
    final currency = Currency(result.key, result.name, result.value, result.timestamp, isEnabled: isEnabled);
    _currencies.replaceWhere((it) => it.key == key, currency);
  }

  @override
  Future<void> disableCurrency(String key) => _setEnabled(key, false);

  @override
  Future<void> enableCurrency(String key, int position) => _setEnabled(key, true);

  @override
  Stream<List<Currency>> getCurrencies() async* {
    yield _currencies;
  }

  @override
  Future<Currency> getCurrency(String key) async => _currencies.firstWhere((it) => it.key == key);

  @override
  Future<int> getEnabledCurrencyCount() async => _currencies.where((it) => it.isEnabled).length;

  @override
  Future<Currency?> getSelectedCurrency() async => _selected;

  @override
  Future<void> setSelectedCurrency(String key) async {
    _selected = await getCurrency(key);
  }
}
