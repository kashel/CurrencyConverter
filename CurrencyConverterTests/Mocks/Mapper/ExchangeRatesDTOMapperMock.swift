//
//  Created by Ireneusz Sołek
//  

import Foundation
@testable import CurrencyConverter

class ExchangeRatesDTOMapperMock: ExchangeRatesDTOMapperProtocol {
  
  var mockModel: ExchangeRateModel!
  var mapCalledForDTOCalled: ExchangeRateDTO?
  func map(dto: ExchangeRateDTO) -> ExchangeRateModel? {
    mapCalledForDTOCalled = dto
    return mockModel
  }
}
