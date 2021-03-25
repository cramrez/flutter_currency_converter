// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Currency _$CurrencyFromJson(Map<String, dynamic> json) {
  return Currency()
    ..key = json['key'] as String
    ..name = json['name'] as String
    ..value = json['value'] as num
    ..timestamp = json['timestamp'] as int;
}

Map<String, dynamic> _$CurrencyToJson(Currency instance) => <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'value': instance.value,
      'timestamp': instance.timestamp,
    };
