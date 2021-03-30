import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_converter/src/database/currency_database.dart';
import 'package:flutter_currency_converter/src/provider/currency_provider.dart';
import 'package:flutter_currency_converter/src/repository/currency_repository.dart';
import 'package:flutter_currency_converter/src/repository/implementation/currency_repository.dart';
import 'package:flutter_currency_converter/src/ui/bottom_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final currencyProvider = CurrencyProvider();
  final localDatabase = await CurrencyDatabase.init();

  final currencyRepo = CurrencyRepository(currencyProvider, localDatabase);

  runApp(
    RepositoryProvider<CurrencyRepositoryBase>(
      create: (_) => currencyRepo,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: BottomBarWidget.create(context),
    );
  }
}
