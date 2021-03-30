import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_converter/src/bloc/converter_cubit.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:provider/provider.dart';

class CalculatorWidget extends StatelessWidget {
  final num currentValue;

  const CalculatorWidget({Key? key, required this.currentValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleCalculator(
      value: currentValue.toDouble(),
      hideExpression: false,
      hideSurroundingBorder: true,
      onChanged: (key, value, expression) => context.read<ConverterCubit>().setAmount(value ?? 0),
    );
  }
}
