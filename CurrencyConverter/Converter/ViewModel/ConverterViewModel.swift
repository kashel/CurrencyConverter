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
    exchangeRateService.exchangeRates(currencyPairs: currentlySelectedPairs) { [weak self](result) in
      guard let self = self else { return }
      switch result {
      case .success(let exchangeRates):
        var isNewRateAdded = false
        if self.previouslySelectedPairs.count != self.currentlySelectedPairs.count {
          self.previouslySelectedPairs = self.currentlySelectedPairs
          isNewRateAdded = true
        }
        DispatchQueue.main.async {
          self.actions?(.dataLoaded(allRates: exchangeRates, isNewRateAdded: isNewRateAdded))          
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func addCurrencyPair() {
    coordinator?.addCurrencyPair()
  }
  
  func currencyPairAdded(_ currencyPair: CurrencyPair) {
    currentlySelectedPairs.insert(currencyPair, at: 0)
    startLoading()
  }
}
