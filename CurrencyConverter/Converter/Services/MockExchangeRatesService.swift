//
//  Created by Ireneusz Sołek
//  

import Foundation

struct MockExchangeRatesService: ExchangeRatesServiceProtocol {
  var currencyPairs: [CurrencyPair] = []
  func exchangeRates(currencyPairs: [CurrencyPair], completed: ExchangeRatesServiceProtocol.LoadingCompleted) -> ExchangeRatesServiceProtocol.CancelClosure {
    let exchangeRates = currencyPairs.map { currencyPair in
      ExchangeRateModel(sourceCurrency: currencyPair.send,
                        sourceAmount: 1,
                        receiveCurrency: currencyPair.receive, receiveAmount: 1.2345)
    }
    
    completed(.success(exchangeRates))
    return {}
  }
}
