import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_converter/src/bloc/converter_cubit.dart';
import 'package:flutter_currency_converter/src/bloc/currency_cubit.dart';
import 'package:flutter_currency_converter/src/model/currency.dart';
import 'package:flutter_currency_converter/src/repository/currency_repository.dart';
import 'package:flutter_currency_converter/src/ui/calculator.dart';
import 'package:flutter_currency_converter/src/utils/currency_symbols.dart';
import 'package:provider/provider.dart';

class ConverterScreen extends StatelessWidget {
  static Widget create(BuildContext context) {
    return BlocProvider(
      create: (_) => ConverterCubit(context.read<CurrencyCubit>(), context.read<CurrencyRepositoryBase>()),
      child: ConverterScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: BlocBuilder<ConverterCubit, ConverterState>(builder: (context, state) {
        if (state is ConverterReadyState) {
          return Column(
            children: <Widget>[
              _SelectedRow(state.amountConverting, state.selected),
              // if (context.watch<SettingsCubit>().showTutorial) TutorialWidget(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    // TODO Refresh currencis
                  },
                  child: ReorderableListView(
                    onReorder: (int oldIndex, int newIndex) async {
                      await context.read<ConverterCubit>().reOrder(oldIndex, newIndex);
                    },
                    children: state.currencies.map((it) => _CurrencyRow(it)).toList(),
                  ),
                ),
              )
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}

class _AppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:
          Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Currency Converter',
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        const SizedBox(width: 4, height: 4),
        BlocBuilder<ConverterCubit, ConverterState>(
          builder: (context, state) {
            return Text(
              state is ConverterReadyState ? state.timestamp : 'Updating...',
              style: const TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w300),
            );
          },
        )
      ]),
    );
  }
}

class _SelectedRow extends StatelessWidget {
  final num _amountConverting;
  final Currency _selected;

  const _SelectedRow(this._amountConverting, this._selected);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).accentColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Image.asset('assets/flags/${_selected.key}.png'),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          _selected.key,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (_) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.75,
                                    child: BlocProvider(
                                      create: (_) => context.read<ConverterCubit>(),
                                      child: CalculatorWidget(currentValue: _amountConverting),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.black, width: 1),
                              ),
                              height: 40,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${getCurrencySymbol(_selected.key)} $_amountConverting',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(height: 4),
                    Text(_selected.name),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class _CurrencyRow extends StatelessWidget {
  final WrapperCurrency currency;

  _CurrencyRow(this.currency) : super(key: ValueKey(currency.key));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          onTap: () async => await onTap(context),
          title: Text(currency.key),
          subtitle: Text(currency.name),
          leading: Image.asset('assets/flags/${currency.key}.png'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '${getCurrencySymbol(currency.key)} ${currency.resultSelectedTo}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '1 ${currency.key} = ${currency.resultOneToSelected} ${currency.selectedKey}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10.0,
                ),
              ),
            ],
          )),
    );
  }

  Future<void> onTap(BuildContext context) => context.read<CurrencyCubit>().setSelected(currency.key);
}