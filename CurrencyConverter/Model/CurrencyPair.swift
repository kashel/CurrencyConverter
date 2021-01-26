//
//  Created by Ireneusz Sołek
//  

import Foundation

struct CurrencyPair: Codable, Equatable, Hashable {
  let send: Currency
  let receive: Currency
}
