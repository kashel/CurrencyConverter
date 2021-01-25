//
//  Created by Ireneusz Sołek
//  

import Foundation

final class DependencyContainer {}

extension DependencyContainer: CurrencyServiceFactory {
  var currencyService: CurrencyServiceProtocol {
    return CurrencyService()
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
    return CurrencyPairService()
  }
}

final class MockDependencyContainer {}

extension MockDependencyContainer: CurrencyServiceFactory {
  var currencyService: CurrencyServiceProtocol {
    return CurrencyService()
  }
}

extension MockDependencyContainer: ExchangeRatesServiceFactory {
  var exchangeRatesService: ExchangeRatesServiceProtocol {
    let mockService = ExchangeRatesServiceMock()
    mockService.exchangeRateResult = .success([ExchangeRateModel(sourceCurrency: .polishZloty, sourceAmount: 1, receiveCurrency: .usDolar, receiveAmount: 4.1234)])
    return mockService
  }
}

extension MockDependencyContainer: CurrencyPairServiceFactory {
  var currencyPairService: CurrencyPairServiceProtocol {
    let mockService = CurrencyPairServiceMock()
    mockService.currencyPairs = [CurrencyPair(send: .polishZloty, receive: .usDolar)]
    return mockService
  }
}
