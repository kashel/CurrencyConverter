//
//  Created by Ireneusz Sołek
//  

@testable import CurrencyConverter

class CurrencyPairServiceMock: CurrencyPairServiceProtocol {
  var savedCurrencyPairsCalled = false
  var currencyPairs: [CurrencyPair] = []
  var savedCurrencyPairs: [CurrencyPair] {
    savedCurrencyPairsCalled = true
    return currencyPairs
  }
  
  var insertCalledWithCurrencyPair: CurrencyPair?
  func insert(currencyPair: CurrencyPair) {
    insertCalledWithCurrencyPair = currencyPair
  }
  
  var deleteCalledWithCurrencyPair: CurrencyPair?
  func delete(currencyPair: CurrencyPair) {
    deleteCalledWithCurrencyPair = currencyPair
  }
}
