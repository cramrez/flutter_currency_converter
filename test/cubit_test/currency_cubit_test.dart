import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_currency_converter/src/bloc/currency_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/mock_currency_repository.dart';

void main() {
  late MockCurrencyRepository currencyRepository;
  late CurrencyCubit currencyCubit;


  setUp(() {
    currencyRepository = MockCurrencyRepository();
    currencyCubit = CurrencyCubit(currencyRepository);
  });

  blocTest<CurrencyCubit, CurrencyState>(
    'Currency cubit initialize correctly',
    build: () => currencyCubit,
    verify: (CurrencyCubit cubit) {
      expect(cubit.state is CurrencyReadyState, true);

      final state = cubit.state as CurrencyReadyState;
      expect(state.currencies.length, 5);
      expect(state.currencies[0].key, 'EUR');
      expect(state.currencies[1].key, 'CNY');
      expect(state.currencies[2].key, 'USD');
      expect(state.currencies[3].key, 'JPY');
      expect(state.currencies[4].key, 'MXN');

      expect(state.selected.key, 'EUR');
    },
  );

  blocTest<CurrencyCubit, CurrencyState>(
    'Currency cubit enable correctly',
    build: () => currencyCubit,
    expect: () => [isA<CurrencyReadyState>()],
    verify: (CurrencyCubit cubit) {
      final state = cubit.state as CurrencyReadyState;
      expect(state.currencies.where((it) => it.isEnabled).length, 5);
    },
  );

  blocTest<CurrencyCubit, CurrencyState>(
    'Currency cubit disable correctly',
    build: () => currencyCubit,
    act: (cubit) async {
      await Future.delayed(Duration(milliseconds: 1));
      cubit.setEnabled('USD', false);
      cubit.setEnabled('MXN', false);
    },
    verify: (CurrencyCubit cubit) {
      final state = cubit.state as CurrencyReadyState;
      expect(state.currencies.where((it) => it.isEnabled).length, 3);
    },
  );

  blocTest<CurrencyCubit, CurrencyState>(
    'Cannot disable selected currency',
    build: () => currencyCubit,
    act: (cubit) async {
      await Future.delayed(Duration(milliseconds: 1));
      cubit.setEnabled('EUR', false);
    },
    wait: Duration(milliseconds: 150),
    expect: () => [
      isA<CurrencyReadyState>(),
      isA<CurrencyWarningState>(),
      isA<CurrencyReadyState>(),
    ],
  );

  blocTest<CurrencyCubit, CurrencyState>(
    'Cannot have less than 2 currencies enabled',
    build: () => currencyCubit,
    act: (cubit) async {
      await Future.delayed(Duration(milliseconds: 1));
      cubit.setEnabled('CNY', false);
      cubit.setEnabled('USD', false);
      cubit.setEnabled('JPY', false);
      cubit.setEnabled('MXN', false);
    },
    wait: Duration(milliseconds: 150),
    expect: () => [
      isA<CurrencyReadyState>(),
      isA<CurrencyWarningState>(),
      isA<CurrencyReadyState>(),
    ],
  );
}
