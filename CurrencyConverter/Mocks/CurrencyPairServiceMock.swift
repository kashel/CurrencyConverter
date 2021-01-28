//
//  Created by Ireneusz Sołek
//  

class CurrencyPairServiceMock: CurrencyPairServiceProtocol {
  let exchangeRatesServiceMock: ExchangeRatesServiceMock?
  var savedCurrencyPairsCalled = false
  var currencyPairs: [CurrencyPair] = []
  
  init(exchangeRatesServiceMock: ExchangeRatesServiceMock? = nil) {
    self.exchangeRatesServiceMock = exchangeRatesServiceMock
  }
  
  var savedCurrencyPairs: [CurrencyPair] {
    savedCurrencyPairsCalled = true
    return currencyPairs
  }
  
  var insertCalledWithCurrencyPair: CurrencyPair?
  func insert(currencyPair: CurrencyPair) {
    insertCalledWithCurrencyPair = currencyPair
    if let exchangeRatesServiceMock = exchangeRatesServiceMock, let result = exchangeRatesServiceMock.exchangeRateResult, case .success(let currentExchangeRates) = result {
      var currentRates = currentExchangeRates
      let newExchangeRate = ExchangeRateModel(sourceCurrency: currencyPair.send, sourceAmount: 1, receiveCurrency: currencyPair.receive, receiveAmount: 1.2345)
      currentRates.insert(newExchangeRate, at: 0)
      exchangeRatesServiceMock.exchangeRateResult = .success(currentRates)
    }
  }
  
  var deleteCalledWithCurrencyPairs: Set<CurrencyPair>?
  func delete(currencyPairs: Set<CurrencyPair>) {
    self.currencyPairs.removeFirst(currencyPairs.count)
    deleteCalledWithCurrencyPairs = currencyPairs
  }
}
