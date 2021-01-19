//
//  Created by Ireneusz Sołek
//  

import Foundation

class ConverterViewModel {
  enum Action {
    case dataLoaded(allRates: [ExchangeRateModel], isNewRateAdded: Bool)
  }
  weak var coordinator: ConverterCoordinator?
  let currencyPairService: CurrencyPairServiceProtocol
  let exchangeRateService: ExchangeRatesServiceProtocol
  var previouslySelectedPairs: [CurrencyPair] = []
  var currentlySelectedPairs: [CurrencyPair] {
    didSet {
      previouslySelectedPairs = oldValue
    }
  }
  
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
        var isNewRateAdded = false
        if previouslySelectedPairs.count != currentlySelectedPairs.count {
          previouslySelectedPairs = currentlySelectedPairs
          isNewRateAdded = true
        }
        actions?(.dataLoaded(allRates: exchangeRates, isNewRateAdded: isNewRateAdded))
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func addCurrencyPair() {
    coordinator?.addCurrencyPair()
  }
  
  func currencyPairAdded(_ currencyPair: CurrencyPair) {
    print("jestem tutaj z taką parą: \(currencyPair)")
    currentlySelectedPairs.insert(currencyPair, at: 0)
    startLoading()
  }
}
