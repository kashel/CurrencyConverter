//
//  Created by Ireneusz Sołek
//  

import Foundation

struct ExchangeRateDTO {
  let currencySymbolsPair: String
  let exchangeRate: Decimal
}

struct ExchangeRatesDTO: Decodable {
  var array: [ExchangeRateDTO]
  private struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
      self.stringValue = stringValue
    }
    var intValue: Int?
    init?(intValue: Int) {
      return nil
    }
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
    
    var tempArray = [ExchangeRateDTO]()
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.numberStyle = .decimal
    formatter.usesGroupingSeparator = false
    formatter.maximumFractionDigits = 4
    
    for key in container.allKeys {
      let exchangeRateDouble = try container.decode(Double.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
      let exchangeRateString = formatter.string(for: exchangeRateDouble)
      guard let exchangeRate = exchangeRateString, let decimal = Decimal(string: exchangeRate) else {
        throw DecodingError.dataCorruptedError(forKey: key, in: container, debugDescription: "Invalid numeric value.")
      }
      let exchangeRateDTO = ExchangeRateDTO(currencySymbolsPair: key.stringValue, exchangeRate: decimal)
      tempArray.append(exchangeRateDTO)
    }
    
    array = tempArray
  }
}
