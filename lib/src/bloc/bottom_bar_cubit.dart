import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_converter/src/ui/bottom_bar.dart';

class BottomBarCubit extends Cubit<BottomNavItem> {
  BottomBarCubit() : super(BottomNavItem.converter);

  void onChanged(BottomNavItem item) => emit(item);
}
