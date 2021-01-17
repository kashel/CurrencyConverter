//
//  Created by Ireneusz Sołek
//  

import Foundation

protocol CurrencyPairServiceProtocol {
  var savedCurrencyPairs: [CurrencyPair] { get }
}

class CurrencyPairService: CurrencyPairServiceProtocol {
  let currencyServiceMock = CurrencySerive()
  
  var savedCurrencyPairs: [CurrencyPair] {
    let sendCurrency = currencyServiceMock.availableCurrencies[0]
    let receiveCurrency = currencyServiceMock.availableCurrencies[1]
    return [CurrencyPair(send: sendCurrency, receive: receiveCurrency)]
  }
}
