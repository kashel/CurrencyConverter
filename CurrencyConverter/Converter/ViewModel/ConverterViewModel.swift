//
//  Created by Ireneusz Sołek
//  

import Foundation
import os.log

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
  var pendingDispatchWork: DispatchWorkItem?
  
  init(currencyPairService: CurrencyPairServiceProtocol, exchangeRateService: ExchangeRatesServiceProtocol) {
    self.currencyPairService = currencyPairService
    self.exchangeRateService = exchangeRateService
    currentlySelectedPairs = currencyPairService.savedCurrencyPairs
  }
  
  var actions: ((Action) -> Void)?
  
  func startLoading() {
    os_log("irek start loading started", log: OSLog.debug, type: .error)
    pendingDispatchWork?.cancel()
    let newDispatchWork = DispatchWorkItem { [weak self] in
      os_log("irek dispatch work item started", log: OSLog.debug, type: .error)
      guard let self = self else { return }
      self.exchangeRateService.exchangeRates(currencyPairs: self.currentlySelectedPairs) { [weak self](result) in
        guard let self = self else { return }
        switch result {
        case .success(let exchangeRates):
          var isNewRateAdded = false
          if self.previouslySelectedPairs.count != self.currentlySelectedPairs.count {
            self.previouslySelectedPairs = self.currentlySelectedPairs
            isNewRateAdded = true
          }
          DispatchQueue.main.sync {
            self.actions?(.dataLoaded(allRates: exchangeRates, isNewRateAdded: isNewRateAdded))
          }
        case .failure(let error):
          switch error {
          case .network(let networkError):
            os_log("Failed fetching the data from remote", log: OSLog.data, type: .error, networkError.localizedDescription)
          case .parsing:
            os_log("Unable to parse exchage rates network response, check the contract", log: OSLog.data, type: .error)
            assertionFailure("ExchangeRatesDTO parsing failed, check the network contract")
          }
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
    currentlySelectedPairs.insert(currencyPair, at: 0)
    startLoading()
  }
}
