//
//  Created by Ireneusz Sołek
//  

import Foundation

protocol CurrencyPairServiceFactory {
  var currencyPairService: CurrencyPairServiceProtocol { get }
}
protocol CurrencyPairServiceProtocol {
  var savedCurrencyPairs: [CurrencyPair] { get }
  func insert(currencyPair: CurrencyPair)
  func delete(currencyPairs: Set<CurrencyPair>)
}

class CurrencyPairService: CurrencyPairServiceProtocol {
  let userDefaults: UserDefaults
  let userDefaultsKey = "savedCurrencies"
  let encoder = JSONEncoder()
  let decoder = JSONDecoder()
  
  init(userDefaults: UserDefaults = .standard) {
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
  
  func insert(currencyPair: CurrencyPair) {
    var mutableCurrencyCollection = savedCurrencyPairs
    mutableCurrencyCollection.insert(currencyPair, at: 0)
    save(currencyPairs: mutableCurrencyCollection)
  }
  
  func delete(currencyPairs currencyPairsToDelete: Set<CurrencyPair>) {
    let newCurrencyPairsCollection = savedCurrencyPairs.filter { !currencyPairsToDelete.contains($0) }
    save(currencyPairs: newCurrencyPairsCollection)
  }
}

private extension CurrencyPairService {
  func save(currencyPairs: [CurrencyPair]) {
    guard let encoded = try? encoder.encode(currencyPairs) else {
      assertionFailure("Unable to encode curriencies collection: \(currencyPairs)")
      return
    }
    userDefaults.set(encoded, forKey: userDefaultsKey)
  }
}
