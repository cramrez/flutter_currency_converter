import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency.g.dart';

@JsonSerializable()
class Currency extends Equatable {
  late final String key;
  late final String name;
  late final num value;
  late final int timestamp;

  bool get isBase => key == 'EUR';

  @override
  List<Object?> get props => throw UnimplementedError();
}
