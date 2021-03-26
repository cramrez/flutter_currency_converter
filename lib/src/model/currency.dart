import 'package:equatable/equatable.dart';

class Currency extends Equatable {
  final String key;
  final String name;
  final num value;
  final int timestamp;


  Currency(this.key, this.name, this.value, this.timestamp);

  bool get isBase => key == 'EUR';

  @override
  List<Object?> get props => [key, value, timestamp];
}
