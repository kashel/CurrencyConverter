//
//  Created by Ireneusz Sołek
//  

import UIKit

class ConverterCoordinator: Coordinator {
  typealias Dependencies = ExchangeRatesServiceFactory & CurrencyPairServiceFactory
  var childCoordinators: [Coordinator] = []
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)?
  var rootViewController: ConverterViewController!
  var rootViewModel: ConverterViewModel!
  
  let exchangeRateService: ExchangeRatesServiceProtocol
  let currencyPairService: CurrencyPairServiceProtocol
  
  init(dependencies: Dependencies) {
    self.exchangeRateService = dependencies.exchangeRatesService
    self.currencyPairService = dependencies.currencyPairService
  }
  
  func start() -> UIViewController {
    rootViewModel = ConverterViewModel(currencyPairService: currencyPairService, exchangeRateService: exchangeRateService)
    rootViewModel.coordinator = self
    rootViewController = ConverterViewController(viewModel: rootViewModel, cellModelMapper: ExchangeRateCellModelMapper())
    return rootViewController
  }
  
  func addCurrencyPair() {
    let currencySelectionCoordinator = CurrencySelectionCoordinator()
    add(childCoordinator: currencySelectionCoordinator)
    let currencySelectionViewController = currencySelectionCoordinator.start()
    currencySelectionCoordinator.lifecycle = { [weak self, weak currencySelectionCoordinator] coordinatorLifecycleEvent -> Void in
      guard case .canceled = coordinatorLifecycleEvent else { return }
      if let currencySelectionCoordinator = currencySelectionCoordinator {
        self?.remove(childCoordinator: currencySelectionCoordinator)
      }
      self?.rootViewController.dismiss(animated: true)
    }
    currencySelectionCoordinator.didSelectCurrencyPair = {[weak self, weak currencySelectionCoordinator] currencyPair in
      if let currencySelectionCoordinator = currencySelectionCoordinator {
        self?.remove(childCoordinator: currencySelectionCoordinator)
      }
      self?.rootViewController.dismiss(animated: true) {
        self?.rootViewModel.currencyPairAdded(currencyPair)
      }
    }
    
    currencySelectionViewController.modalPresentationStyle = .formSheet
    rootViewController.present(currencySelectionViewController, animated: true, completion: nil)
  }
}
