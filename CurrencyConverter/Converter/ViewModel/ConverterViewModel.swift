//
//  Created by Ireneusz Sołek
//  

import Foundation
import os.log

class ConverterViewModel {
  enum Action {
    case loading
    case initialDataLoaded(rates: [ExchangeRateModel])
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
  var pendingDispatchWork: DispatchWorkItem?
  
  init(currencyPairService: CurrencyPairServiceProtocol, exchangeRateService: ExchangeRatesServiceProtocol) {
    self.currencyPairService = currencyPairService
    self.exchangeRateService = exchangeRateService
    currentlySelectedPairs = currencyPairService.savedCurrencyPairs
  }
  
  var actions: ((Action) -> Void)?
  
  func startLoading() {
    DispatchQueue.main.async {
      if self.previouslySelectedPairs.count == 0 {
        self.actions?(.loading)
      }
    }
    pendingDispatchWork?.cancel()
    let newDispatchWork = DispatchWorkItem { [weak self] in
      guard let self = self else { return }
      self.exchangeRateService.exchangeRates(currencyPairs: self.currentlySelectedPairs) { [weak self](result) in
        guard let self = self else { return }
        switch result {
        case .success(let exchangeRates):
          DispatchQueue.main.sync {
            self.notifyExchangeRatesChange(with: exchangeRates)
          }
        case .failure(let error):
          self.logLoadingError(error)
        }
        self.startLoading()
      }
    }
    pendingDispatchWork = newDispatchWork
    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: newDispatchWork)
  }
  
  func addCurrencyPair() {
    coordinator?.addCurrencyPair()
  }
  
  func currencyPairAdded(_ currencyPair: CurrencyPair) {
    pendingDispatchWork?.cancel()
    DispatchQueue.main.async {
      self.currentlySelectedPairs.insert(currencyPair, at: 0)
    }
    startLoading()
  }
  
  private func logLoadingError(_ error: ExchangeRateServiceError) {
    switch error {
    case .network(let networkError):
      os_log("Failed fetching the data from remote", log: OSLog.data, type: .error, networkError.localizedDescription)
    case .parsing:
      os_log("Unable to parse exchage rates network response, check the contract", log: OSLog.data, type: .error)
      assertionFailure("ExchangeRatesDTO parsing failed, check the network contract")
    }
  }
  
  private func notifyExchangeRatesChange(with exchangeRates: [ExchangeRateModel]) {
    guard exchangeRates.count == currentlySelectedPairs.count else { return }
    if previouslySelectedPairs.count == 0 {
      self.actions?(.initialDataLoaded(rates: exchangeRates))
      previouslySelectedPairs = currentlySelectedPairs
      return
    }
    let newRateAdded = (currentlySelectedPairs.count - previouslySelectedPairs.count) == 1
    previouslySelectedPairs = currentlySelectedPairs
    self.actions?(.dataLoaded(allRates: exchangeRates, isNewRateAdded: newRateAdded))
  }
}
