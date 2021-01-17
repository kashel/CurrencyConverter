//
//  Created by Ireneusz Sołek
//  

import Foundation

protocol CurrencySelectionCellModelMapperProtocol {
  func map(_: CurrencySelection) -> CurrencySelectionCellModel
}

struct CurrencySelectionCellModelMapper: CurrencySelectionCellModelMapperProtocol {
  func map(_ currencySelection: CurrencySelection) -> CurrencySelectionCellModel {
    return CurrencySelectionCellModel(currencyName: currencySelection.currency.name, currencyCode: currencySelection.currency.code, icon: currencySelection.currency.flag, isSelectable: currencySelection.isActive)
  }
}
