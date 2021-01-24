//
//  Created by Ireneusz Sołek
//  

import Foundation
@testable import CurrencyConverter

extension CurrencyPair {
  static var mock: CurrencyPair {
    return CurrencyPair(send: Currency(code: "USD", countryCode: "US"), receive: Currency(code: "PLN", countryCode: "PL"))
  }
}
