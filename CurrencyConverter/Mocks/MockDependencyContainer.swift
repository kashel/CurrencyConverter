//
//  Created by Ireneusz Sołek
//  

import Foundation

final class MockDependencyContainer {
  private let launchScreen: LaunchScreen
  
  init(launchScreen: LaunchScreen) {
    self.launchScreen = launchScreen
  }
  
  lazy var mockExchangeRatesService: ExchangeRatesServiceMock = {
    let mockService = ExchangeRatesServiceMock()
    mockService.exchangeRateResult = .success([ExchangeRateModel(sourceCurrency: .polishZloty, sourceAmount: 1, receiveCurrency: .usDolar, receiveAmount: 4.1234)])
    return mockService
  }()
}

extension MockDependencyContainer: CurrencyServiceFactory {
  var currencyService: CurrencyServiceProtocol {
    return CurrencyService()
  }
}

extension MockDependencyContainer: ExchangeRatesServiceFactory {
  var exchangeRatesService: ExchangeRatesServiceProtocol {
    return mockExchangeRatesService
  }
}

extension MockDependencyContainer: CurrencyPairServiceFactory {
  var currencyPairService: CurrencyPairServiceProtocol {
    let mockService = CurrencyPairServiceMock(exchangeRatesServiceMock: mockExchangeRatesService)
    mockService.currencyPairs = launchScreen == .dashboard ? [] : [CurrencyPair(send: .polishZloty, receive: .usDolar)]
    return mockService
  }
}
