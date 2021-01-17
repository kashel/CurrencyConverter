//
//  Created by Ireneusz Sołek
//  

import Foundation

struct ConverterViewModel {
  enum Action {
    case dataLoaded([ExchangeRateModel])
  }
  
  let initialPairs: [CurrencyPair]
  let exchangeRateService: ExchangeRatesServiceProtocol
  var actions: ((Action) -> Void)?
  
  func startLoading() {
    exchangeRateService.exchangeRates(currencyPairs: initialPairs) { (result) in
      switch result {
      case .success(let exchangeRates):
        actions?(.dataLoaded(exchangeRates))
      case .failure(let error):
        print(error)
      }
    }
  }
}
