import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_converter/src/extensions/list_extension.dart';
import 'package:flutter_currency_converter/src/model/currency.dart';
import 'package:flutter_currency_converter/src/repository/currency_repository.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  final CurrencyRepositoryBase _repository;

  late final StreamSubscription subscription;

  late List<Currency> _currencies;
  late Currency? _selected;

  CurrencyCubit(this._repository) : super(CurrencyLoadingState()) {
    _init();
  }

  Future<void> _init() async {
    // If there are no currency enabled we set some defaults
    final enabledCount = await _repository.getEnabledCurrencyCount();
    if (enabledCount == 0) {
      await _repository.enableCurrency('EUR', 0);
      await _repository.enableCurrency('CNY', 1);
      await _repository.enableCurrency('USD', 2);
      await _repository.enableCurrency('JPY', 3);
      await _repository.enableCurrency('MXN', 4);
    }

    subscription = _repository.getCurrencies().listen((currencyList) async {
      _currencies = currencyList;
      if (_currencies.isNotEmpty) {

        // If there is no selected currency we set EUR as default
        _selected = await _repository.getSelectedCurrency();
        if (_selected == null) {
          await _repository.setSelectedCurrency('EUR');
          _selected = await _repository.getSelectedCurrency();
        }



        emit(CurrencyReadyState(_currencies, _selected!));
      }
    });
  }

  Future<void> setEnabled(String key, bool isEnabled) async {
    if (_selected?.key == key) {
      setWarning('Cannot disable selected currency');
    } else if (!isEnabled && _totalEnabledCurrencies <= 2) {
      setWarning('Cannot disable all currencies');
    } else {
      if (isEnabled) {
        await _repository.enableCurrency(key, 9999);
      } else {
        await _repository.disableCurrency(key);
      }
      final edited = await _repository.getCurrency(key);
      _currencies = List.from(_currencies)..replaceWhere((it) => it.key == key, edited);
      emit(CurrencyReadyState(_currencies, _selected!));
    }
  }

  void setWarning(String message) async {
    emit(CurrencyWarningState(message));
    await Future.delayed(Duration(milliseconds: 100));
    emit(CurrencyReadyState(_currencies, _selected!));
  }

  int get _totalEnabledCurrencies => _currencies.where((it) => it.isEnabled).length;

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}

class CurrencyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CurrencyLoadingState extends CurrencyState {}

class CurrencyReadyState extends CurrencyState {
  final List<Currency> currencies;
  final Currency selected;

  CurrencyReadyState(this.currencies, this.selected);

  @override
  List<Object> get props => [currencies, selected];
}

class CurrencyWarningState extends CurrencyState {
  final String message;

  CurrencyWarningState(this.message);

  @override
  List<Object> get props => [message];
}
