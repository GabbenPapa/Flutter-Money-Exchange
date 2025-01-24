class BaseCurrencyModel {
  final String baseCode;
  final Map<String, num> conversionRates;

  BaseCurrencyModel({
    required this.baseCode,
    required this.conversionRates,
  });
}
