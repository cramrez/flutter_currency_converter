import 'package:flutter_currency_converter/src/model/currency.dart';

abstract class CurrencyRepositoryBase {
  Future<List<Currency>> getCurrencies();
}
