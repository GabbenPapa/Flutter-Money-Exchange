class CurrancyPairModel {
  final String baseCurrency;
  final String targetCurrency;
  final num conversionRate;

  CurrancyPairModel({
    required this.baseCurrency,
    required this.targetCurrency,
    required this.conversionRate,
  });

  @override
  String toString() {
    return 'CurrancyPairModel{baseCurrency: $baseCurrency, targetCurrency: $targetCurrency, conversionRate: $conversionRate}';
  }
}
