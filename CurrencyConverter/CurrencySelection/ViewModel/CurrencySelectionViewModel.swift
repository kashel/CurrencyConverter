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
  
  lazy var title: String = {
    switch ctaAction {
    case .currencyPairSelected:
      return "Receive currency"
    case.goToReceiveCurrencySelection:
      return "Send currency"
    }
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
  
  private func produceCellData(for ctaAction: CTAAction) -> [CurrencySelection] {
    let model: [CurrencySelection]
    switch ctaAction {
    case .goToReceiveCurrencySelection:
      let disabledCurrencies = Set(currencyService.availableCurrencies.filter{ sendCurrency in
        currencyPairService.savedCurrencyPairs.filter{ $0.send == sendCurrency }.count == currencyService.supportedCurrenciesCount - 1
      })
      model = currencyService.availableCurrencies.map{ CurrencySelection(isActive: !disabledCurrencies.contains($0), currency: $0)}
    case .currencyPairSelected(let sendCurrency):
      var disabledCurrencies = Set(currencyPairService.savedCurrencyPairs.filter{ $0.send == sendCurrency }.map{ $0.receive })
      disabledCurrencies.insert(sendCurrency)
      model = currencyService.availableCurrencies.map{ CurrencySelection(isActive: !disabledCurrencies.contains($0), currency: $0)}
    }
    return model
  }
  
  func continueAction(selectedCurrency: Currency) {
    switch ctaAction {
    case .goToReceiveCurrencySelection:
      coordinator?.selectReceiveCurrency(previouslySelected: selectedCurrency)
    case .currencyPairSelected(let sendCurrency):
      //TODO: save in persistent storage
      coordinator?.currencyPairSelected(CurrencyPair(send: sendCurrency, receive: selectedCurrency))
    }
  }
  
  func cancelAction() {
    coordinator?.selectionCanceled()
  }
}
