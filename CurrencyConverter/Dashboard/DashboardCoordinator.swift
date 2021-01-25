//
//  Created by Ireneusz Sołek
//  

import UIKit

protocol DashboardCoordinatorProtocol: AnyObject {
  func continueToCurrencySelection()
}

class DashboardCoordinator: Coordinator, DashboardCoordinatorProtocol {
  typealias Dependencies = CurrencySelectionCoordinator.Dependencies
  var childCoordinators: [Coordinator] = []
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)?
  var rootViewController: DashboardViewConroller!
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  func start() -> UIViewController {
    let dashboardViewModel = DashboardViewModel(coordinator: self)
    rootViewController = DashboardViewConroller(viewModel: dashboardViewModel)
    return rootViewController
  }
  
  func continueToCurrencySelection() {
    let currencySelectionCoordinator = CurrencySelectionCoordinator(dependencies: dependencies)
    add(childCoordinator: currencySelectionCoordinator)
    currencySelectionCoordinator.lifecycle = { [weak self] coordinatorLifecycleEvent -> Void in
      switch coordinatorLifecycleEvent {
      case .canceled(let childCoordinator):
        self?.remove(childCoordinator: childCoordinator)
        self?.rootViewController.dismiss(animated: true)
      case .finished(let childCoordinator):
        self?.remove(childCoordinator: childCoordinator)
        self?.rootViewController.dismiss(animated: true) { [weak self] in
          guard let unownedSelf = self else { return }
          unownedSelf.lifecycle?(.finished(unownedSelf))
        }
      }
    }
    let currencySelectionViewController = currencySelectionCoordinator.start()
    currencySelectionViewController.modalPresentationStyle = .fullScreen
    rootViewController.present(currencySelectionViewController, animated: true, completion: nil)
  }
}
