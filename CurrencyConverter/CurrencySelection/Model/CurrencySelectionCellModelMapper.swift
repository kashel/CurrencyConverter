//
//  Created by Ireneusz Sołek
//  

import Foundation

protocol CurrencySelectionCellModelMapperProtocol {
  func map(_: CurrencySelectionModel) -> CurrencySelectionCellModel
}

struct CurrencySelectionCellModelMapper: CurrencySelectionCellModelMapperProtocol {
  func map(_ currencySelection: CurrencySelectionModel) -> CurrencySelectionCellModel {
    .init(currencyName: currencySelection.currency.name, currencyCode: currencySelection.currency.code, icon: currencySelection.currency.flag, isSelectable: currencySelection.isActive)
  }
}
