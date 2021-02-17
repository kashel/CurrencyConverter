//
//  Created by Ireneusz Sołek
//  

import Foundation
@testable import CurrencyConverter

extension CurrencyPair {
  static var mock: CurrencyPair {
    return CurrencyPair(send: Currency.usDolar, receive: Currency(code: "PLN", countryCode: "PL"))
  }
}
