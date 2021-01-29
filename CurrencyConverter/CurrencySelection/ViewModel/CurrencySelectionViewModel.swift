//
//  Created by Ireneusz Sołek
//  

import Foundation

struct CurrencySelectionViewModel {
  typealias Dependencies = CurrencyServiceFactory & CurrencyPairServiceFactory
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
  
  lazy var title: String = {
    switch ctaAction {
    case .currencyPairSelected:
      return L10n.receiveCurrency
    case.goToReceiveCurrencySelection:
      return L10n.sendCurrency
    }
  }()
  
  private let ctaAction: CTAAction
  private let currencySelectionCellModelMapper: CurrencySelectionCellModelMapperProtocol
  private let currencyPairService: CurrencyPairServiceProtocol
  private let currencyService: CurrencyServiceProtocol
  private weak var coordinator: CurrencySelectionCoordinator?
  
  init(ctaAction: CTAAction,
       currencySelectionCellModelMapper: CurrencySelectionCellModelMapperProtocol,
       coordinator: CurrencySelectionCoordinator,
       dependencies: Dependencies) {
    self.ctaAction = ctaAction
    self.currencySelectionCellModelMapper = currencySelectionCellModelMapper
    self.currencyPairService = dependencies.currencyPairService
    self.currencyService = dependencies.currencyService
    self.coordinator = coordinator
  }
  
  func continueAction(selectedCurrency: Currency) {
    switch ctaAction {
    case .goToReceiveCurrencySelection:
      coordinator?.selectReceiveCurrency(previouslySelected: selectedCurrency)
    case .currencyPairSelected(let sendCurrency):
      let currencyPairSelected = CurrencyPair(send: sendCurrency, receive: selectedCurrency)
      currencyPairService.insert(currencyPair: currencyPairSelected)
      coordinator?.currencyPairSelected(currencyPairSelected)
    }
  }
  
  func cancelAction() {
    coordinator?.selectionCanceled()
  }
  
  private func produceCellData(for ctaAction: CTAAction) -> [CurrencySelection] {
    let model: [CurrencySelection]
    switch ctaAction {
    case .goToReceiveCurrencySelection:
      let disabledCurrencies = Set(currencyService.availableCurrencies.filter { sendCurrency in
        currencyPairService.savedCurrencyPairs.filter { $0.send == sendCurrency }.count == currencyService.supportedCurrenciesCount - 1
      })
      model = currencyService.availableCurrencies.map { CurrencySelection(isActive: !disabledCurrencies.contains($0), currency: $0)}
    case .currencyPairSelected(let sendCurrency):
      var disabledCurrencies = Set(currencyPairService.savedCurrencyPairs.filter { $0.send == sendCurrency }.map { $0.receive })
      disabledCurrencies.insert(sendCurrency)
      model = currencyService.availableCurrencies.map { CurrencySelection(isActive: !disabledCurrencies.contains($0), currency: $0)}
    }
    return model
  }
}
