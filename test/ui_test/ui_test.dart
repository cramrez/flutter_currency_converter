import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_converter/src/bloc/navigation_cubit.dart';
import 'package:flutter_currency_converter/src/bloc/settings_cubit.dart';
import 'package:flutter_currency_converter/src/repository/currency_repository.dart';
import 'package:flutter_currency_converter/src/ui/bottom_bar.dart';
import 'package:flutter_currency_converter/src/ui/converter_screen.dart';
import 'package:flutter_currency_converter/src/ui/favorites_screen.dart';
import 'package:flutter_currency_converter/src/ui/settings_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/mock_currency_repository.dart';

void main() {
  late MockCurrencyRepository currencyRepository;
  late SettingsCubit settingsCubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    currencyRepository = MockCurrencyRepository();
    settingsCubit = await SettingsCubit().init();
  });

  Widget getApp({required Widget child}) {
    return RepositoryProvider<CurrencyRepositoryBase>(
      create: (context) => currencyRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => settingsCubit),
          BlocProvider(create: (_) => NavigationCubit()),
        ],
        child: MaterialApp(
          home: child,
        ),
      ),
    );
  }

  testWidgets('Test bottom widget navigate correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(getApp(
      child: Builder(
        builder: (context) => BottomBarWidget.create(context),
      ),
    ));
    await tester.pumpAndSettle();

    // At the start ConverterScreen is visible
    expect(find.byType(ConverterScreen), findsOneWidget);
    expect(find.byType(FavoritesScreen), findsNothing);
    expect(find.byType(SettingsScreen), findsNothing);

    // Navigate to favorites
    await tester.tap(find.text(BottomNavItem.favorites.title));
    await tester.pumpAndSettle();
    expect(find.byType(ConverterScreen), findsNothing);
    expect(find.byType(FavoritesScreen), findsOneWidget);
    expect(find.byType(SettingsScreen), findsNothing);

    // Navigate to settings
    await tester.tap(find.text(BottomNavItem.settings.title));
    await tester.pumpAndSettle();
    expect(find.byType(ConverterScreen), findsNothing);
    expect(find.byType(FavoritesScreen), findsNothing);
    expect(find.byType(SettingsScreen), findsOneWidget);
  });

  testWidgets('Test converter screen show defaults correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      getApp(
        child: Builder(
          builder: (context) => ConverterScreen.create(context),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Selected currency is found
    expect(find.text('EUR'), findsOneWidget);
    expect(find.text('CNY'), findsOneWidget);
    expect(find.text('USD'), findsOneWidget);
    expect(find.text('JPY'), findsOneWidget);
    expect(find.text('MXN'), findsOneWidget);
  });

  testWidgets('Disabled currencies will not show in the convertor screen',
      (WidgetTester tester) async {
    // I disable the currencies first
    await currencyRepository.disableCurrency('CNY');
    await currencyRepository.disableCurrency('USD');

    await tester.pumpWidget(
      getApp(
        child: Builder(
          builder: (context) => ConverterScreen.create(context),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Selected currency is found
    expect(find.text('EUR'), findsOneWidget);
    expect(find.text('CNY'), findsNothing);
    expect(find.text('USD'), findsNothing);
    expect(find.text('JPY'), findsOneWidget);
    expect(find.text('MXN'), findsOneWidget);
  });

  testWidgets('Favorites screen will show defaults',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      getApp(
        child: Builder(
          builder: (context) => FavoritesScreen.create(context),
        ),
      ),
    );
    await tester.pumpAndSettle();

    Checkbox getCheckBox(String key) =>
        tester.firstWidget(find.byKey(Key(key)));

    // Listview has 6 widgets
    expect(find.byType(ListTile), findsNWidgets(6));

    // Selected currency is found
    expect(find.text('EUR (Selected currency)'), findsOneWidget);

    // All currencies are enabled
    expect(getCheckBox('EUR').value, true);
    expect(getCheckBox('CNY').value, true);
    expect(getCheckBox('USD').value, true);
    expect(getCheckBox('JPY').value, true);
    expect(getCheckBox('MXN').value, true);
  });

  testWidgets('Filter random text will only show the selected currency',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      getApp(
        child: Builder(
          builder: (context) => FavoritesScreen.create(context),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'a%kdQ2');
    await tester.pumpAndSettle();

    // Selected currency is found
    expect(find.byType(ListTile), findsNWidgets(1));
    expect(find.text('EUR (Selected currency)'), findsOneWidget);
  });

  testWidgets('Favorite Screen: Tapping a currency will disable it',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      getApp(
        child: Builder(
          builder: (context) => FavoritesScreen.create(context),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Before tapping there are 5 currencies enabled
    expect(await currencyRepository.getEnabledCurrencyCount(), 5);

    // Tap to disable USD
    await tester.tap(find.byKey(Key('USD')));
    await tester.pump();

    // After tapping there are 4 currencies enabled
    expect(await currencyRepository.getEnabledCurrencyCount(), 4);
  }, skip: false);
}
