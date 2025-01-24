enum ExchangeError {
  unsupportedCode,
  malformedRequest,
  invalidKey,
  inactiveAccount,
  quotaReached,
}

class ExchangeErrorException implements Exception {
  final ExchangeError? exchangeError;

  ExchangeErrorException(this.exchangeError);

  @override
  String toString() {
    switch (exchangeError) {
      case ExchangeError.unsupportedCode:
        return 'Unsupported code';
      case ExchangeError.malformedRequest:
        return 'Malformed request';
      case ExchangeError.invalidKey:
        return 'Invalid key';
      case ExchangeError.inactiveAccount:
        return 'Inactive account';
      case ExchangeError.quotaReached:
        return 'Quota reached';
      default:
        return 'Unknown error';
    }
  }
}
