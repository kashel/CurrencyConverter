//
//  Created by Ireneusz Sołek
//  

import UIKit

class CurrencySelectionCoordinator: Coordinator {
  typealias Dependencies = CurrencySelectionViewModel.Dependencies
  let rootViewController: UINavigationController
  var childCoordinators: [Coordinator] = []
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)?
  var didSelectCurrencyPair: ((CurrencyPair) -> Void)?
  let currencySelectionCellModelMapper = CurrencySelectionCellModelMapper()
  private let currencyService = CurrencyService()
  private let currencyPairService = CurrencyPairService()
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
    self.rootViewController = UINavigationController()
  }
  
  func start() -> UIViewController {
    let viewModel = CurrencySelectionViewModel(ctaAction: .goToReceiveCurrencySelection,
                                               currencySelectionCellModelMapper: currencySelectionCellModelMapper,
                                               coordinator: self,
                                               dependencies: dependencies)
    let currencySelectionViewController = CurrencySelectionViewController(viewModel: viewModel)
    rootViewController.pushViewController(currencySelectionViewController, animated: false)
    return rootViewController
  }
  
  func selectReceiveCurrency(previouslySelected: Currency) {
    let viewModel = CurrencySelectionViewModel(ctaAction: .currencyPairSelected(sendCurrency: previouslySelected),
                                               currencySelectionCellModelMapper: currencySelectionCellModelMapper,
                                               coordinator: self,
                                               dependencies: dependencies)
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
