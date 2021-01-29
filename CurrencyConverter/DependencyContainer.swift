//
//  Created by Ireneusz Sołek
//  

import Foundation

final class DependencyContainer {}

extension DependencyContainer: CurrencyServiceFactory {
  var currencyService: CurrencyServiceProtocol {
    CurrencyService()
  }
}

extension DependencyContainer: ExchangeRatesServiceFactory {
  var exchangeRatesService: ExchangeRatesServiceProtocol {
    let exchangeRatesDTOMapper = ExchangeRatesDTOMapper(currencyService: currencyService)
    return ExchangeRateService(exchangeRatesDTOMapper: exchangeRatesDTOMapper)
  }
}

extension DependencyContainer: CurrencyPairServiceFactory {
  var currencyPairService: CurrencyPairServiceProtocol {
    CurrencyPairService()
  }
}
