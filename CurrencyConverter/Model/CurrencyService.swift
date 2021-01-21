//
//  Created by Ireneusz Sołek
//  

import Foundation

protocol CurrencyServiceProtocol {
  var availableCurrencies: [Currency] { get }
  var supportedCurrenciesCount: Int { get }
}

class CurrencySerive: CurrencyServiceProtocol {
  typealias CurrencyCode = String
  typealias RegionCode = String
  
  lazy var supportedCurrencyCodes: [String] = {
    [
      "GBP",
      "EUR",
      "USD",
      "AUD",
      "BGN",
      "BRL",
      "CAD",
      "CHF",
      "CNY",
      "CZK",
      "DKK",
      "HKD",
      "HRK",
      "HUF",
      "IDR",
      "ILS",
      "INR",
      "ISK",
      "JPY",
      "KRW",
      "MXN",
      "MYR",
      "NOK",
      "NZD",
      "PHP",
      "PLN",
      "RON",
      "RUB",
      "SEK",
      "SGD",
      "THB",
      "ZAR"
    ]
  }()
  
  lazy var supportedCurrenciesCount: Int = supportedCurrencyCodes.count
  
  var availableCurrencies: [Currency] {
    supportedCurrencyCodes.compactMap{
      guard let countryCode = countryCode(for: $0) else {
        assertionFailure("Unable to map currency: \($0) to country code")
        return nil
      }
      return Currency(code: $0, countryCode: countryCode)
    }
  }
  
  func findAvailableCurrency(by currencyCode: String) -> Currency? {
    return availableCurrencies.first(where: { $0.code == currencyCode })
  }
  
  private lazy var supportedCurrencyCodesSet: Set<String> = {
    Set(supportedCurrencyCodes)
  }()
  
  private lazy var supportedCurrenciesToRegionMap: [CurrencyCode: RegionCode] = {
    let localeIds = Locale.availableIdentifiers
    var currencyToCountryCodeMap: [CurrencyCode: RegionCode] = [:]
    
    localeIds.forEach{
      let locale = Locale(identifier: $0)
      let currencyCode = locale.currencyCode ?? ""
      if supportedCurrencyCodesSet.contains(currencyCode) {
        currencyToCountryCodeMap[currencyCode] = locale.regionCode
      }
    }
    return currencyToCountryCodeMap
  }()
  
  private func countryCode(for currencyCode: CurrencyCode) -> RegionCode? {
    return supportedCurrenciesToRegionMap.first { (key, _) -> Bool in
      key == currencyCode
    }?.value
  }
}
