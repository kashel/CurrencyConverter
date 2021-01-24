//
//  Created by Ireneusz Sołek
//  

@testable import CurrencyConverter

extension ExchangeRateModel {
  static var mock: ExchangeRateModel = ExchangeRateModel(sourceCurrency: Currency.usDolar, sourceAmount: 0, receiveCurrency: Currency.usDolar, receiveAmount: 0)
}
