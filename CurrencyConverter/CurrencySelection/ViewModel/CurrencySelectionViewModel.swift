//
//  Created by Ireneusz Sołek
//  

import Foundation

struct CurrencySelectionViewModel {
  enum CTAAction {
    case goToReceiveCurrencySelection
    case currencyPairSelected
  }
  
  private let ctaAction: CTAAction
  private let currencySelectionCellModelMapper: CurrencySelectionCellModelMapperProtocol
  let model: [CurrencySelection]
  var cellsData: [CurrencySelectionCellModel] {
    model.map(currencySelectionCellModelMapper.map)
  }
  
  init(model: [CurrencySelection], ctaAction: CTAAction, currencySelectionCellModelMapper: CurrencySelectionCellModelMapperProtocol) {
    self.model = model
    self.ctaAction = ctaAction
    self.currencySelectionCellModelMapper = currencySelectionCellModelMapper
  }
  
  func continueAction() {
    switch ctaAction {
      case .currencyPairSelected:
      print("currencyPairSelected")
    case .goToReceiveCurrencySelection:
      print("currencyPairSelected")
    }
  }
}
