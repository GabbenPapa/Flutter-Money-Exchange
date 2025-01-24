import 'dart:convert';

import 'package:http/http.dart' as http;
import 'base_currency_model.dart';
import 'currancy_pair_model.dart';
import 'exchange_error.dart';

abstract class ExchangeInterface {
  Future<BaseCurrencyModel> fetchBaseCurrency(String currency);
  Future<CurrancyPairModel> fetchCurrancyPair(
      String baseCurrency, String targetCurrency);
}

class RemoteService implements ExchangeInterface {
  static const _apiKey = '674a00b84f734df0e7b73224';
  static const _baseUrl = 'https://v6.exchangerate-api.com/v6/';

  @override
  Future<BaseCurrencyModel> fetchBaseCurrency(String currency) async {
    http.Response? result;

    try {
      result = await http.get(
        Uri.parse(
          '$_baseUrl/$_apiKey/latest/$currency',
        ),
      );
    } catch (e) {
      _throwException(null);
    }

    if (result.statusCode == 200) {
      var resultObject = jsonDecode(result.body);

      return BaseCurrencyModel(
          baseCode: resultObject['base_code'],
          conversionRates: Map.from(
            resultObject['conversion_rates'],
          ));
    } else {
      _throwException(result.body);
    }
  }

  @override
  Future<CurrancyPairModel> fetchCurrancyPair(
      String baseCurrency, String targetCurrency) async {
    http.Response? result;
    try {
      result = await http.get(
        Uri.parse(
          '$_baseUrl/$_apiKey/pair/$baseCurrency/$targetCurrency',
        ),
      );
    } catch (e) {
      _throwException(null);
    }

    if (result.statusCode == 200) {
      var resultObject = jsonDecode(result.body);

      return CurrancyPairModel(
        baseCurrency: resultObject['base_code'],
        targetCurrency: resultObject['target_code'],
        conversionRate: resultObject['conversion_rate'],
      );
    } else {
      _throwException(result.body);
    }
  }

  Never _throwException([String? body]) {
    if (body != null) {
      throw NetworkErrorException();
    }
    var errorObj = jsonDecode(body!);
    String? error = errorObj['error-type'];

    if (error == null) {
      throw ExchangeErrorException(null);
    } else if (error == 'unsupported-code') {
      throw ExchangeErrorException(ExchangeError.unsupportedCode);
    } else if (error == 'malformed-request') {
      throw ExchangeErrorException(ExchangeError.malformedRequest);
    } else if (error == 'invalid-key') {
      throw ExchangeErrorException(ExchangeError.invalidKey);
    } else if (error == 'inactive-account') {
      throw ExchangeErrorException(ExchangeError.inactiveAccount);
    } else if (error == 'quota-reached') {
      throw ExchangeErrorException(ExchangeError.quotaReached);
    }
    throw ExchangeErrorException(null);
  }
}

class NetworkErrorException implements Exception {
  NetworkErrorException();
}
