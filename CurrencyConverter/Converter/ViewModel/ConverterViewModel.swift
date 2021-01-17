//
//  Created by Ireneusz Sołek
//  

import Foundation

struct ConverterViewModel {
  enum Action {
    case dataLoaded([ExchangeRateModel])
  }
  
  let currencyPairService: CurrencyPairServiceProtocol
  let exchangeRateService: ExchangeRatesServiceProtocol
  var currentlySelectedPairs: [CurrencyPair]
  
  init(currencyPairService: CurrencyPairServiceProtocol, exchangeRateService: ExchangeRatesServiceProtocol) {
    self.currencyPairService = currencyPairService
    self.exchangeRateService = exchangeRateService
    currentlySelectedPairs = currencyPairService.savedCurrencyPairs
  }
  
  var actions: ((Action) -> Void)?
  
  func startLoading() {
    exchangeRateService.exchangeRates(currencyPairs: currentlySelectedPairs) { (result) in
      switch result {
      case .success(let exchangeRates):
        actions?(.dataLoaded(exchangeRates))
      case .failure(let error):
        print(error)
      }
    }
  }
}
