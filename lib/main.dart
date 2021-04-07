import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_converter/src/bloc/settings_cubit.dart';
import 'package:flutter_currency_converter/src/provider/db_provider.dart';
import 'package:flutter_currency_converter/src/provider/rest_provider.dart';
import 'package:flutter_currency_converter/src/repository/currency_repository.dart';
import 'package:flutter_currency_converter/src/repository/implementation/currency_repository.dart';
import 'package:flutter_currency_converter/src/ui/bottom_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final restProvider = RestProvider();
  final dbProvider = await DbProvider().init();

  final currencyRepo = CurrencyRepository(restProvider, dbProvider);
  final settingsCubit = await SettingsCubit().init();

  runApp(
    RepositoryProvider<CurrencyRepositoryBase>(
      create: (_) => currencyRepo,
      child: BlocProvider(
        create: (_) => settingsCubit,
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Currency Convertor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BottomBarWidget.create(context),
    );
  }
}
