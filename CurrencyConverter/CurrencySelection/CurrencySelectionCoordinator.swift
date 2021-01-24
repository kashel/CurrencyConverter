//
//  Created by Ireneusz Sołek
//  

import UIKit

class CurrencySelectionCoordinator: Coordinator {
  let rootViewController: UINavigationController
  var childCoordinators: [Coordinator] = []
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)?
  var didSelectCurrencyPair: ((CurrencyPair) -> Void)?
  let currencySelectionCellModelMapper = CurrencySelectionCellModelMapper()
  private let currencyService = CurrencyService()
  private let currencyPairService = CurrencyPairService()
  
  init() {
    self.rootViewController = UINavigationController()
  }
  
  func start() -> UIViewController {
    let viewModel = CurrencySelectionViewModel(ctaAction: .goToReceiveCurrencySelection,
                                               currencySelectionCellModelMapper: currencySelectionCellModelMapper,
                                               currencyPairService: currencyPairService,
                                               currencyService: currencyService,
                                               coordinator: self)
    let currencySelectionViewController = CurrencySelectionViewController(viewModel: viewModel)
    rootViewController.pushViewController(currencySelectionViewController, animated: false)
    return rootViewController
  }
  
  func selectReceiveCurrency(previouslySelected: Currency) {
    let viewModel = CurrencySelectionViewModel(ctaAction: .currencyPairSelected(sendCurrency: previouslySelected),
                                               currencySelectionCellModelMapper: currencySelectionCellModelMapper,
                                               currencyPairService: currencyPairService,
                                               currencyService: currencyService,
                                               coordinator: self)
    let currencySelectionViewController = CurrencySelectionViewController(viewModel: viewModel)
    rootViewController.pushViewController(currencySelectionViewController, animated: true)
  }
  
  func currencyPairSelected(_ currencyPair: CurrencyPair) {
    didSelectCurrencyPair?(currencyPair)
    lifecycle?(.finished(self))
  }
  
  func selectionCanceled() {
    lifecycle?(.canceled(self))
  }
}
