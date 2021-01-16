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
    
    let model = [CurrencySelection(isActive: true, currency: Currency(name: "Brithis Pound")),
                 CurrencySelection(isActive: false, currency: Currency(name: "Euro"))] + (1...100).map{ CurrencySelection(isActive: true, currency: Currency(name: "Currency: \($0)")) }
    let viewModel = CurrencySelectionViewModel(model: model, ctaAction: .goToReceiveCurrencySelection, currencySelectionCellModelMapper: currencySelectionCellModelMapper, previouslySelected: nil, coordinator: self)
    let currencySelectionViewController = CurrencySelectionViewController(viewModel: viewModel)
    rootViewController.pushViewController(currencySelectionViewController, animated: false)
    return rootViewController
  }
  
  func selectReceiveCurrency(model: [CurrencySelection], previouslySelected: CurrencySelection) {
    let viewModel = CurrencySelectionViewModel(model: model, ctaAction: .currencyPairSelected, currencySelectionCellModelMapper: currencySelectionCellModelMapper, previouslySelected: previouslySelected, coordinator: self)
    let currencySelectionViewController = CurrencySelectionViewController(viewModel: viewModel)
    rootViewController.pushViewController(currencySelectionViewController, animated: true)
  }
  
  func currencyPairSelected(sendCurrency: Currency, receiveCurrency: Currency) {
    print("selected currency pair: \(sendCurrency) \(receiveCurrency)")
    lifecycle?(.finished(self))
  }
}
