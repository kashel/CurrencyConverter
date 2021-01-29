//
//  Created by Ireneusz Sołek
//  

import Foundation
@testable import CurrencyConverter

class CurrencySelectionCellModelMapperMock: CurrencySelectionCellModelMapperProtocol {
  
  var currencySelectionCellModel: CurrencySelectionCellModel?
  func map(_: CurrencySelection) -> CurrencySelectionCellModel {
    return currencySelectionCellModel!
  }
}
