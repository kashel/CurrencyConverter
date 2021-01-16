//
//  Created by Ireneusz Sołek
//  

import Foundation

struct CurrencySelectionViewModel {
  enum CTAAction {
    case goToReceiveCurrencySelection
    case currencyPairSelected
  }
  
  let model: [CurrencySelection]
  var cellsData: [CurrencySelectionCellModel] {
    model.map(currencySelectionCellModelMapper.map)
  }
  
  private let ctaAction: CTAAction
  private let currencySelectionCellModelMapper: CurrencySelectionCellModelMapperProtocol
  private let coordinator: CurrencySelectionCoordinator
  private let previouslySelected: CurrencySelection?
  
  init(model: [CurrencySelection], ctaAction: CTAAction, currencySelectionCellModelMapper: CurrencySelectionCellModelMapperProtocol, previouslySelected: CurrencySelection?, coordinator: CurrencySelectionCoordinator) {
    self.model = model
    self.ctaAction = ctaAction
    self.currencySelectionCellModelMapper = currencySelectionCellModelMapper
    self.previouslySelected = previouslySelected
    self.coordinator = coordinator
  }
  
  func continueAction(selectedCurrency: CurrencySelection) {
    switch ctaAction {
      case .currencyPairSelected:
      //TODO: save in persistent storage
      coordinator.currencyPairSelected(sendCurrency: previouslySelected!.currency, receiveCurrency: selectedCurrency.currency)
      print("currencyPairSelected")
    case .goToReceiveCurrencySelection:
      coordinator.selectReceiveCurrency(model: model, previouslySelected: selectedCurrency)
      print("currencyPairSelected")
    }
  }
}
