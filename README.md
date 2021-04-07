# Flutter Currency Converter

Flutter Version: Stable 2.0.4

- Learn how to use manage states using [Flutter Bloc](https://pub.dev/packages/flutter_bloc)
- Local data persistence using [SQFLite](https://pub.dev/packages/sqflite)
- Separate the app in multiple layers (presentation, business logic, data)
- Make request to a Rest API using [Http](https://pub.dev/packages/http)
- Unit test & widget test
- Handle exceptions

# Architecture

![Image 1](https://github.com/Yayo-Arellano/flutter_currency_converter/blob/master/images/Architecture.png?raw=true)

# Prerequisites

- Get an API key from [https://fixer.io/](https://fixer.io/)
- Add the API key in the `RestProvider` class

  ````
  class RestProvider {
    static const String _accessKey = '<Your API key>';
  ````

- Run the command `flutter pub run build_runner watch --delete-conflicting-outputs` to generate the code.

# Screenshots

| Converter Screen | Favorites Screen | Settings Screen |
| ---------------- | --------------------- | --------------------- |
| ![Image 1](https://github.com/Yayo-Arellano/flutter_currency_converter/blob/master/images/Image%201.png?raw=true) |![Image 2](https://github.com/Yayo-Arellano/flutter_currency_converter/blob/master/images/Image%202.png?raw=true) |![Image 3](https://github.com/Yayo-Arellano/flutter_currency_converter/blob/master/images/Image%203.png?raw=true) |

