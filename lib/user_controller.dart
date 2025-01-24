import 'currancy_pair_model.dart';

import 'exchange_error.dart';
import 'remote_service.dart';

class UserController {
  final ExchangeInterface remoteService;
  final Stream<String> input;
  final void Function(List<CurrancyPairModel>) setResultList;
  final void Function(String) onErrorMessage;

  UserController(
      this.remoteService, this.input, this.setResultList, this.onErrorMessage);

  void startUserLoop() async {
    await for (var currencyCommand in input) {
      try {
        if (currencyCommand.contains('-')) {
          var baseCurrency = currencyCommand.split('-')[0];
          var targetCurrency = currencyCommand.split('-')[1];
          var result = await remoteService.fetchCurrancyPair(
            baseCurrency,
            targetCurrency,
          );
          setResultList([result]);
          onErrorMessage(
              '${result.baseCurrency}-${result.targetCurrency}: ${result.conversionRate}');
        } else {
          var result = await remoteService.fetchBaseCurrency(currencyCommand);
          setResultList(result.conversionRates.entries
              .map((entry) => CurrancyPairModel(
                    baseCurrency: result.baseCode,
                    targetCurrency: entry.key,
                    conversionRate: entry.value,
                  ))
              .toList());
        }
      } on NetworkErrorException {
        onErrorMessage('Network Error');
      } on ExchangeErrorException catch (e) {
        switch (e.exchangeError) {
          case ExchangeError.unsupportedCode:
            onErrorMessage('Unsupported code');
            break;

          case ExchangeError.malformedRequest:
            onErrorMessage('Malformed request');
            break;
          case ExchangeError.invalidKey:
            onErrorMessage('Invalid key');
            break;
          case ExchangeError.inactiveAccount:
            onErrorMessage('Inactive account');
            break;
          case ExchangeError.quotaReached:
            onErrorMessage('Quota reached');
            break;
          case null:
            onErrorMessage('Exchange Error');
            break;
        }
      } catch (e) {
        onErrorMessage(e.toString());
      }
    }
  }
}
