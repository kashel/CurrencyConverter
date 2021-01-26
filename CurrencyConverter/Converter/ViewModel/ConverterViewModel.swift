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
    case allDataRemoved
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
  var cancelExchangeRangeFetching: ExchangeRatesServiceProtocol.CancelClosure?
  
  init(currencyPairService: CurrencyPairServiceProtocol, exchangeRateService: ExchangeRatesServiceProtocol) {
    self.currencyPairService = currencyPairService
    self.exchangeRateService = exchangeRateService
    currentlySelectedPairs = currencyPairService.savedCurrencyPairs
  }
  
  var actions: ((Action) -> Void)?
  
  lazy var notifyInitialDataLoading: (() -> Void)? = {
    DispatchQueue.main.async {
      self.actions?(.loading)
    }
  }
  
  func startLoading() {
    if previouslySelectedPairs.count == 0 {
      notifyInitialDataLoading?()
      notifyInitialDataLoading = nil
    }
    pendingDispatchWork?.cancel()
    let newDispatchWork = DispatchWorkItem { [weak self] in
      guard let self = self, self.currentlySelectedPairs.count > 0 else { return }
      self.cancelExchangeRangeFetching = self.exchangeRateService.exchangeRates(currencyPairs: self.currentlySelectedPairs) { [weak self](result) in
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
    cancelLoading()
    DispatchQueue.main.async {
      self.currentlySelectedPairs.insert(currencyPair, at: 0)
    }
    startLoading()
  }
  
  func viewDidDeleteCurrencyPairAt(indexes: [Int]) {
    let currencyPairsToDelete = indexes.map{ currentlySelectedPairs[$0] }
    currencyPairService.delete(currencyPairs: Set(currencyPairsToDelete))
    currentlySelectedPairs = currencyPairService.savedCurrencyPairs
    if currencyPairService.savedCurrencyPairs.count == 0 {
      actions?(.allDataRemoved)
    }
  }
  
  func viewDidChangeDataProcessingCapability(canProcessData: Bool) {
    if canProcessData == false {
      cancelLoading()
    } else {
      startLoading()
    }
  }
}

private extension ConverterViewModel {
  func cancelLoading() {
    pendingDispatchWork?.cancel()
    cancelExchangeRangeFetching?()
  }
  
  func logLoadingError(_ error: ExchangeRateServiceError) {
    switch error {
    case .network(let networkError):
      os_log("Failed fetching the data from remote", log: OSLog.data, type: .error, networkError.localizedDescription)
    case .parsing:
      os_log("Unable to parse exchage rates network response, check the contract", log: OSLog.data, type: .error)
      assertionFailure("ExchangeRatesDTO parsing failed, check the network contract")
    }
  }
  
  func notifyExchangeRatesChange(with exchangeRates: [ExchangeRateModel]) {
    guard exchangeRates.count == currentlySelectedPairs.count else {
      assertionFailure("race condition detected in currentlySelectedPairs property")
      return
    }
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
