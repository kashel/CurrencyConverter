//
//  Created by Ireneusz Sołek
//  

import UIKit

class ConverterCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)?
  var rootViewController: ConverterViewController!
  var rootViewModel: ConverterViewModel!
  
  func start() -> UIViewController {
    let exchangeRateService = MockExchangeRatesService()
    let currencyPairService = CurrencyPairService()
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
    currencySelectionCoordinator.didSelectCurrencyPair = {[weak self] currencyPair in
      self?.rootViewController.dismiss(animated: true) {
        self?.rootViewModel.currencyPairAdded(currencyPair)
      }
    }
    
    currencySelectionViewController.modalPresentationStyle = .formSheet
    rootViewController.present(currencySelectionViewController, animated: true, completion: nil)
  }
}
