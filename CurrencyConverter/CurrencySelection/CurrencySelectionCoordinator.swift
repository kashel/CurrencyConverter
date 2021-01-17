//
//  Created by Ireneusz Sołek
//  

import UIKit

class CurrencySelectionCoordinator: Coordinator {
  let rootViewController: UINavigationController
  var childCoordinators: [Coordinator] = []
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)?
  let currencySelectionCellModelMapper = CurrencySelectionCellModelMapper()
  
  init() {
    self.rootViewController = UINavigationController()
  }
  
  func start() -> UIViewController {
    let currencyPairService = CurrencyPairService()
    let currencyService = CurrencySerive()
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
    let currencyPairService = CurrencyPairService()
    let currencyService = CurrencySerive()
    let viewModel = CurrencySelectionViewModel(ctaAction: .currencyPairSelected(sendCurrency: previouslySelected),
                                               currencySelectionCellModelMapper: currencySelectionCellModelMapper,
                                               currencyPairService: currencyPairService,
                                               currencyService: currencyService,
                                               coordinator: self)
    let currencySelectionViewController = CurrencySelectionViewController(viewModel: viewModel)
    rootViewController.pushViewController(currencySelectionViewController, animated: true)
  }
  
  func currencyPairSelected(sendCurrency: Currency, receiveCurrency: Currency) {
    print("selected currency pair: \(sendCurrency) \(receiveCurrency)")
    lifecycle?(.finished(self))
  }
}
