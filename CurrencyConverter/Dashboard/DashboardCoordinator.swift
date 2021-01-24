//
//  Created by Ireneusz Sołek
//  

import UIKit

class DashboardCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)?
  var rootViewController: DashboardViewConroller!
  
  init() {}
  
  func start() -> UIViewController {
    let dashboardViewModel = DashboardViewModel(coordinator: self)
    rootViewController = DashboardViewConroller(viewModel: dashboardViewModel)
    return rootViewController
  }
  
  func continueToCurrencySelection() {
    let currencySelectionCoordinator = CurrencySelectionCoordinator()
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
