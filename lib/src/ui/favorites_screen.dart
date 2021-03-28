import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_converter/src/bloc/currency_cubit.dart';
import 'package:flutter_currency_converter/src/bloc/favorites_cubit.dart';
import 'package:flutter_currency_converter/src/model/currency.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  static Widget create(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoritesCubit(
        context.read<CurrencyCubit>(),
      ),
      child: FavoritesScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorites currencies")),
      body: BlocListener<CurrencyCubit, CurrencyState>(
        listener: (context, state) {
          if (state is CurrencyWarningState) {
            final snackBar = SnackBar(content: Text(state.message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: BlocBuilder<FavoritesCubit, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteReadyState) {
              return Column(
                children: [
                  _SearchInputWidget(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.currencies.length + 1,
                      itemBuilder: (context, int index) {
                        if (index == 0) {
                          return SelectedCurrencyRow(state.selected);
                        } else {
                          return CurrencyRow(state.currencies[index - 1]);
                        }
                      },
                    ),
                  )
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class CurrencyRow extends StatelessWidget {
  final Currency currency;

  const CurrencyRow(this.currency);

  Future<void> setEnabled(BuildContext context, Currency currency) =>
      context.read<CurrencyCubit>().setEnabled(currency.key, !currency.isEnabled);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async => setEnabled(context, currency),
        title: Text(currency.key),
        subtitle: Text(currency.name),
        leading: const Icon(Icons.flag),
        trailing: Checkbox(
          value: currency.isEnabled,
          onChanged: (bool? value) async => setEnabled(context, currency),
        ),
      ),
    );
  }
}

class SelectedCurrencyRow extends StatelessWidget {
  final Currency currency;

  const SelectedCurrencyRow(this.currency);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${currency.key} (Selected currency)'),
        subtitle: Text(currency.name),
        leading: const Icon(Icons.flag),
      ),
    );
  }
}

class _SearchInputWidget extends StatefulWidget {
  @override
  _SearchInputWidgetState createState() => _SearchInputWidgetState();
}

class _SearchInputWidgetState extends State<_SearchInputWidget> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      context.read<FavoritesCubit>().filterCurrencies(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          labelText: 'Search currency',
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () => _controller.clear(),
                  icon: const Icon(Icons.clear),
                ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
