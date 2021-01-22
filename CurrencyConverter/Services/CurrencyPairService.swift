//
//  Created by Ireneusz Sołek
//  

import Foundation

protocol CurrencyPairServiceProtocol {
  var savedCurrencyPairs: [CurrencyPair] { get }
  func save(currencyPair: CurrencyPair)
}

class CurrencyPairService: CurrencyPairServiceProtocol {
  let currencyService: CurrencyServiceProtocol
  let userDefaults: UserDefaults
  let userDefaultsKey = "savedCurrencies"
  let encoder = JSONEncoder()
  let decoder = JSONDecoder()
  
  init(currencyService: CurrencyServiceProtocol, userDefaults: UserDefaults = .standard) {
    self.currencyService = currencyService
    self.userDefaults = userDefaults
  }
  
  var savedCurrencyPairs: [CurrencyPair] {
    guard let data = userDefaults.object(forKey: userDefaultsKey) as? Data else {
      return []
    }
    guard let currencyPairs = try? decoder.decode([CurrencyPair].self, from: data) else {
      assertionFailure("Unable to decode saved currency pairs")
      return []
    }
    return currencyPairs
  }
  
  func save(currencyPair: CurrencyPair) {
    var currenciesCurrentlySaved = savedCurrencyPairs
    currenciesCurrentlySaved.insert(currencyPair, at: 0)
    guard let encoded = try? encoder.encode(currenciesCurrentlySaved) else {
      assertionFailure("Unable to encode curriencies collection: \(currenciesCurrentlySaved)")
      return
    }
    userDefaults.set(encoded, forKey: userDefaultsKey)
  }
}
