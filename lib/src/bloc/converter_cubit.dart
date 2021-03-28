import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_converter/src/bloc/currency_cubit.dart';
import 'package:flutter_currency_converter/src/model/currency.dart';

class ConverterCubit extends Cubit<ConverterState> {
  final CurrencyCubit _currencyCubit;

  late final StreamSubscription subscription;
  late Currency _selected;

  List<Currency> _enabledCurrencies = [];

  num amountToConvert = 1.0;

  ConverterCubit(this._currencyCubit) : super(ConverterLoadingState()) {
    _init();
  }

  Future<void> _init() async {
    subscription = _currencyCubit.stream.listen((state) async {
      if (state is CurrencyReadyState) {
        _selected = state.selected;

        // Keep only enabled
        _enabledCurrencies = state.currencies.where((it) => it.isEnabled).toList();

        // Remove selected one
        _enabledCurrencies.removeWhere((it) => it.key == _selected.key);

        _updateState();
      }
    });
  }

  void setAmount(num amount) {
    this.amountToConvert = amount;
    _updateState();
  }

  void _updateState() {
    final wrapper = _enabledCurrencies.map((it) {
      final resultSelectedTo = (amountToConvert / _selected.value) * it.value;
      final resultOneToSelected = (1 / it.value) * _selected.value;

      return WrapperCurrency(
        it.position,
        it.key,
        it.name,
        _selected.key,
        resultSelectedTo,
        resultOneToSelected,
      );
    }).toList();
    final date = DateTime.fromMillisecondsSinceEpoch(_selected.timestamp * 1000).toIso8601String();
    emit(ConverterReadyState(wrapper, amountToConvert, _selected, date));
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}

class ConverterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConverterLoadingState extends ConverterState {}

class ConverterReadyState extends ConverterState {
  final List<WrapperCurrency> currencies;
  final num amountConverting;
  final Currency selected;
  final String timestamp;

  ConverterReadyState(
    this.currencies,
    this.amountConverting,
    this.selected,
    this.timestamp,
  );

  @override
  List<Object> get props => [currencies];
}

class WrapperCurrency extends Equatable {
  final int index;
  final String key;
  final String name;
  final String selectedKey;
  final num resultSelectedTo;
  final num resultOneToSelected;

  WrapperCurrency(
    this.index,
    this.key,
    this.name,
    this.selectedKey,
    this.resultSelectedTo,
    this.resultOneToSelected,
  );

  @override
  List<Object> get props => [
        index,
        key,
        selectedKey,
        resultSelectedTo,
        resultOneToSelected,
      ];
}
