//
//  Created by Ireneusz Sołek
//  

import UIKit

class CurrencySelectionCoordinator: Coordinator {
  weak var rootViewController: UINavigationController?
  var childCoordinators: [Coordinator] = []
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)?
  
  init(rootViewController: UINavigationController?) {
    self.rootViewController = rootViewController
  }
  
  func start() -> UIViewController {
    let model = [CurrencySelection(isActive: true, currency: Currency(name: "Brithis Pound")),
                    CurrencySelection(isActive: true, currency: Currency(name: "Euro"))]
    let mapper = CurrencySelectionCellModelMapper()
    let viewModel = CurrencySelectionViewModel(model: model, ctaAction: .goToReceiveCurrencySelection, currencySelectionCellModelMapper: mapper)
    let currencySelectionViewController = CurrencySelectionViewController(viewModel: viewModel)
    return currencySelectionViewController
  }
}
