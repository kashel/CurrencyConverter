//
//  Created by Ireneusz Sołek
//  

import Foundation

struct ExchangeRatesDTOMapper {
  let currencyService = CurrencySerive()
  func map(dto: ExchangeRateDTO) -> ExchangeRateModel {
    let sendCurrencyCode = String(dto.currencySymbolsPair.prefix(3)).uppercased()
    let receiveCurrencyCode = String(dto.currencySymbolsPair.suffix(3)).uppercased()
    
    
    guard let sendCurrency = currencyService.findAvailableCurrency(by: sendCurrencyCode), let receiveCurrency = currencyService.findAvailableCurrency(by: receiveCurrencyCode) else {
      fatalError()
    }
    
    return ExchangeRateModel(sourceCurrency: sendCurrency, sourceAmount: 1, receiveCurrency: receiveCurrency, receiveAmount: dto.exchangeRate)
  }
}
