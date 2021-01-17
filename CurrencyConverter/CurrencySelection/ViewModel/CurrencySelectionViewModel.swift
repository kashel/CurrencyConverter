//
//  Created by Ireneusz Sołek
//  

import Foundation

struct CurrencySelectionViewModel {
  enum CTAAction {
    case goToReceiveCurrencySelection
    case currencyPairSelected(sendCurrency: Currency)
  }
  
  lazy var model: [CurrencySelection] = {
    produceCellData(for: ctaAction)
  }()
  
  lazy var cellsData: [CurrencySelectionCellModel] = {
    model.map(currencySelectionCellModelMapper.map)
  }()
  
  private let ctaAction: CTAAction
  private let currencySelectionCellModelMapper: CurrencySelectionCellModelMapperProtocol
  private let currencyPairService: CurrencyPairServiceProtocol
  private let currencyService: CurrencyServiceProtocol
  private weak var coordinator: CurrencySelectionCoordinator?
  
  init(ctaAction: CTAAction,
       currencySelectionCellModelMapper: CurrencySelectionCellModelMapperProtocol,
       currencyPairService: CurrencyPairServiceProtocol,
       currencyService: CurrencyServiceProtocol,
       coordinator: CurrencySelectionCoordinator) {
    self.ctaAction = ctaAction
    self.currencySelectionCellModelMapper = currencySelectionCellModelMapper
    self.currencyPairService = currencyPairService
    self.currencyService = currencyService
    self.coordinator = coordinator
  }
  
  func produceCellData(for ctaAction: CTAAction) -> [CurrencySelection] {
    let model: [CurrencySelection]
    switch ctaAction {
    case .currencyPairSelected(let sendCurrency):
      model = currencyService.availableCurrencies.map{ CurrencySelection(isActive: true, currency: $0)}
    case .goToReceiveCurrencySelection:
      model = currencyService.availableCurrencies.map{ CurrencySelection(isActive: true, currency: $0)}
      //TODO: disable currencies with no corresponding receive currency
    }
    return model
  }
  
  func continueAction(selectedCurrency: Currency) {
    switch ctaAction {
    case .goToReceiveCurrencySelection:
      coordinator?.selectReceiveCurrency(previouslySelected: selectedCurrency)
    case .currencyPairSelected(let sendCurrency):
      //TODO: save in persistent storage
      coordinator?.currencyPairSelected(sendCurrency: sendCurrency, receiveCurrency: selectedCurrency)
    }
  }
}
