import 'package:equatable/equatable.dart';

class Currency extends Equatable {
  final String key;
  final String name;
  final num value;
  final int timestamp;

  // Part 2. When I start creating the favorite cubit
  final bool isEnabled;

  Currency(this.key, this.name, this.value, this.timestamp, {this.isEnabled = false});

  bool get isBase => key == 'EUR';

  @override
  List<Object?> get props => [key, value, timestamp, isEnabled];

  Map<String, dynamic> toMapDB() {
    return <String, dynamic>{
      'key': key,
      'name': name,
      'value': value,
      'timestamp': timestamp,
    };
  }

  Currency.fromMapDB(Map<String, dynamic> dbData)
      : key = dbData['key'],
        name = dbData['name'],
        value = dbData['value'],
        timestamp = dbData['timestamp'],
        isEnabled = dbData['isEnabled'] == 1;
}
