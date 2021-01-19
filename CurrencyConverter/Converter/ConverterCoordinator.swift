//
//  Created by Ireneusz Sołek
//  

import UIKit

class ConverterCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)?
  var rootViewController: ConverterViewController!
  
  func start() -> UIViewController {
    let exchangeRateService = MockExchangeRatesService()
    let currencyPairService = CurrencyPairService()
    var viewModel = ConverterViewModel(currencyPairService: currencyPairService, exchangeRateService: exchangeRateService)
    viewModel.coordinator = self
    rootViewController = ConverterViewController(viewModel: viewModel, cellModelMapper: ExchangeRateCellModelMapper())
    return rootViewController
  }
  
  func addCurrencyPair() {
    let currencySelectionCoordinator = CurrencySelectionCoordinator()
    add(childCoordinator: currencySelectionCoordinator)
    let currencySelectionViewController = currencySelectionCoordinator.start()
    currencySelectionCoordinator.lifecycle = { [weak self] coordinatorLifecycleEvent -> Void in
      switch coordinatorLifecycleEvent {
      case .canceled(let childCoordinator):
        self?.remove(childCoordinator: childCoordinator)
        self?.rootViewController.dismiss(animated: true)
      case .finished(let childCoordinator):
        self?.remove(childCoordinator: childCoordinator)
        self?.rootViewController.dismiss(animated: true) { [weak self] in
          guard let unownedSelf = self else { return }
          print("currency pair added")
        }
      }
    }
    currencySelectionViewController.modalPresentationStyle = .formSheet
    rootViewController.present(currencySelectionViewController, animated: true, completion: nil)
  }
}
