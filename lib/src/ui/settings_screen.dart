import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_converter/src/bloc/navigation_cubit.dart';
import 'package:flutter_currency_converter/src/bloc/settings_cubit.dart';
import 'package:flutter_currency_converter/src/extensions/context_extension.dart';
import 'package:flutter_currency_converter/src/ui/bottom_bar.dart';

class SettingsScreen extends StatelessWidget {
  static Widget create(BuildContext context) => SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      bottomNavigationBar: BottomNavBar(context.watch<NavigationCubit>().state),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
                child: Text(
              context.formatCurrency(1000000, '\$'),
              style: const TextStyle(fontSize: 23),
            )),
            getDivisor(),
            NumberOfDecimals(),
            getDivisor(),
            GroupingSeparator(),
            getDivisor(),
            DecimalSeparator(),
            getDivisor(),
            CurrencySymbol()
          ],
        ),
      ),
    );
  }

  Widget getDivisor() {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.black,
        ),
      ],
    );
  }
}

class NumberOfDecimals extends StatelessWidget {
  List<DropdownMenuItem<int>> dropDownItems() {
    return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        .map((it) => DropdownMenuItem<int>(
              child: Text('   $it'), // 3 spaces so it look better
              value: it,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SettingsCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Decimals',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Number of decimals to display'),
          ],
        ),
        DropdownButton(
          value: cubit.numberOfDecimals,
          items: dropDownItems(),
          onChanged: (int? value) => cubit.setNumberOfDecimals(value ?? 3),
        ),
      ],
    );
  }
}

class DecimalSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.watch<SettingsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Decimal Separator',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Radio(
              value: true,
              groupValue: settingsCubit.decimalSeparator == '.',
              onChanged: (bool? value) => settingsCubit.setDecimalSeparator(value!),
            ),
            Text('Decimal Point')
          ],
        ),
        Row(
          children: [
            Radio(
              value: false,
              groupValue: settingsCubit.decimalSeparator == '.',
              onChanged: (bool? value) => settingsCubit.setDecimalSeparator(value!),
            ),
            Text('Decimal comma')
          ],
        ),
      ],
    );
  }
}

class CurrencySymbol extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.watch<SettingsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Currency Symbol',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('Choose where to display the currency symbol'),
        Row(
          children: [
            Radio(
              value: true,
              groupValue: settingsCubit.isSymbolAtStart,
              onChanged: (bool? value) => settingsCubit.setSymbolPosition(value!),
            ),
            Text('Start'),
            const SizedBox(width: 50),
            Radio(
              value: false,
              groupValue: settingsCubit.isSymbolAtStart,
              onChanged: (bool? value) => settingsCubit.setSymbolPosition(value!),
            ),
            Text('End')
          ],
        )
      ],
    );
  }
}

class GroupingSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.watch<SettingsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Grouping separator',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Checkbox(
              value: settingsCubit.isGroupSeparatorEnabled,
              onChanged: (bool? value) async => settingsCubit.setGroupingSeparator(value!),
            ),
            Expanded(child: Text('Enable symbol used for thousands separator'))
          ],
        ),
      ],
    );
  }
}
