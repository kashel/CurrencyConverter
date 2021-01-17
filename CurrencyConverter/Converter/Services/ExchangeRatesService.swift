//
//  Created by Ireneusz Sołek
//  

import Foundation

enum ExchangeRateServiceError: Error {
  case network
  case parsing
}

protocol ExchangeRatesServiceProtocol {
  typealias LoadingCompleted =  (Result<[ExchangeRateModel], ExchangeRateServiceError>) -> Void
  func exchangeRates(currencyPairs: [CurrencyPair], completed: LoadingCompleted)
}

struct MockExchangeRatesService: ExchangeRatesServiceProtocol {
  var currencyPairs: [CurrencyPair] = []
  func exchangeRates(currencyPairs: [CurrencyPair], completed: ExchangeRatesServiceProtocol.LoadingCompleted) {
    let exchangeRates = currencyPairs.map { currencyPair in
      ExchangeRateModel(sourceCurrency: currencyPair.send,
                        sourceAmount: 1,
                        receiveCurrency: currencyPair.receive, receiveAmount: 1.2345)
    }
    
    completed(.success(exchangeRates))
  }
}
