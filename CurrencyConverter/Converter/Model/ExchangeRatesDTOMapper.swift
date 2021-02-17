//
//  Created by Ireneusz Sołek
//  

import Foundation

protocol ExchangeRatesDTOMapperProtocol {
  func map(dto: ExchangeRateDTO) -> ExchangeRateModel?
}

struct ExchangeRatesDTOMapper: ExchangeRatesDTOMapperProtocol {
  let currencyService: CurrencyServiceProtocol
  func map(dto: ExchangeRateDTO) -> ExchangeRateModel? {
    let sendCurrencyCode = String(dto.currencySymbolsPair.prefix(3)).uppercased()
    let receiveCurrencyCode = String(dto.currencySymbolsPair.suffix(3)).uppercased()
    
    guard let sendCurrency = currencyService.findAvailableCurrency(by: sendCurrencyCode), let receiveCurrency = currencyService.findAvailableCurrency(by: receiveCurrencyCode) else {
      assertionFailure("unsupported send or receive currency code has been received from the backend")
      return nil
    }
    
    return ExchangeRateModel(sourceCurrency: sendCurrency, sourceAmount: 1, receiveCurrency: receiveCurrency, receiveAmount: dto.exchangeRate)
  }
}
