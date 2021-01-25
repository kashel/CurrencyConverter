//
//  Created by Ireneusz Sołek
//  

@testable import CurrencyConverter

class ExchangeRatesServiceMock: ExchangeRatesServiceProtocol {
  
  var exchangeRateCancelationClosure: () -> Void = {}
  var exchangeRateResult: Result<[ExchangeRateModel], ExchangeRateServiceError>?
  func exchangeRates(currencyPairs: [CurrencyPair], completed: ExchangeRatesServiceProtocol.LoadingCompleted) -> ExchangeRatesServiceProtocol.CancelClosure {    
    if let exchangeRateResult = exchangeRateResult {
      completed(exchangeRateResult)
    }
    return exchangeRateCancelationClosure
  }
}
