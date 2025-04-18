import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:subscription_tracker/services/shared_data.dart';

class CurrencyRepo {
  static const _baseUrl = 'https://open.er-api.com/v6/latest';

  final Map<String, num> _exchangeRates = {};

  CurrencyRepo();

  Future<void> initializeCurrencyRates() async {
    final currencies = SharedData.currencies;

    for (int i = 0; i < currencies.length; i++) {
      final fromCurrency = currencies[i];
      final url = '$_baseUrl/$fromCurrency';
      final response = await http.get(Uri.parse(url));

      // TODO: need to think what to do
      if (response.statusCode != 200 && response.statusCode != 304) {
        continue;
      }

      final exchangeRateResponse = ExchangeRateResponse.fromJson(
        jsonDecode(response.body),
      );

      for (int j = i + 1; j < currencies.length; j++) {
        final toCurrency = currencies[j];
        final rate = exchangeRateResponse.rates[toCurrency];

        if (rate != null) {
          _exchangeRates['${fromCurrency}_$toCurrency'] = rate;
        }
      }
    }
  }

  double convert(double amount, String fromCurrency, String toCurrency) {
    final key = '${fromCurrency}_$toCurrency';
    final reverseKey = '${toCurrency}_$fromCurrency';

    if (_exchangeRates.containsKey(key)) {
      return _exchangeRates[key]! * amount;
    }

    if (_exchangeRates.containsKey(reverseKey)) {
      return amount / _exchangeRates[reverseKey]!;
    }

    return amount;
  }
}

class ExchangeRateResponse {
  final String result;
  final String provider;
  final String documentation;
  final String termsOfUse;
  final int timeLastUpdateUnix;
  final String timeLastUpdateUtc;
  final int timeNextUpdateUnix;
  final String timeNextUpdateUtc;
  final int timeEolUnix;
  final String baseCode;
  final Map<String, num> rates;

  ExchangeRateResponse({
    required this.result,
    required this.provider,
    required this.documentation,
    required this.termsOfUse,
    required this.timeLastUpdateUnix,
    required this.timeLastUpdateUtc,
    required this.timeNextUpdateUnix,
    required this.timeNextUpdateUtc,
    required this.timeEolUnix,
    required this.baseCode,
    required this.rates,
  });

  static ExchangeRateResponse fromJson(Map<String, dynamic> json) {
    return ExchangeRateResponse(
      result: json['result'] as String,
      provider: json['provider'] as String,
      documentation: json['documentation'] as String,
      termsOfUse: json['terms_of_use'] as String,
      timeLastUpdateUnix: json['time_last_update_unix'] as int,
      timeLastUpdateUtc: json['time_last_update_utc'] as String,
      timeNextUpdateUnix: json['time_next_update_unix'] as int,
      timeNextUpdateUtc: json['time_next_update_utc'] as String,
      timeEolUnix: json['time_eol_unix'] as int,
      baseCode: json['base_code'] as String,
      rates: Map<String, num>.from(json['rates']),
    );
  }
}
