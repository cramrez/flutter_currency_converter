import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_converter/src/bloc/currency_cubit.dart';
import 'package:flutter_currency_converter/src/extensions/string_extension.dart';
import 'package:flutter_currency_converter/src/model/currency.dart';

class FavoritesCubit extends Cubit<FavoriteState> {
  final CurrencyCubit _currencyCubit;

  late final StreamSubscription subscription;
  late Currency _selected;

  List<Currency> _currencies = [];

  String filter = '';

  FavoritesCubit(this._currencyCubit) : super(FavoriteLoadingState()) {
    _init();
  }

  Future<void> _init() async {
    subscription = _currencyCubit.stream.listen((state) async {
      if (state is CurrencyReadyState) {
        _currencies = state.currencies;
        _selected = state.selected;
        _updateState();
      }
    });
  }

  void filterCurrencies(String filter) {
    this.filter = filter;
    _updateState();
  }

  void _updateState() {
    if (filter.isNotEmpty) {
      final result = _currencies.where((it) {
        return it.key.containsIgnoreCase(filter) || it.name.containsIgnoreCase(filter);
      }).toList();
      emit(FavoriteReadyState(result, _selected));
    } else {
      emit(FavoriteReadyState(_currencies, _selected));
    }
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}

class FavoriteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoriteLoadingState extends FavoriteState {}

class FavoriteReadyState extends FavoriteState {
  final List<Currency> currencies;
  final Currency selected;

  FavoriteReadyState(this.currencies, this.selected);

  @override
  List<Object> get props => [currencies];
}
